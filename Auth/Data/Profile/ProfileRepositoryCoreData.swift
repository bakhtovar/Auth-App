//
//  ProfileRepositoryCoreData.swift
//  Auth
//
//  Created by Bakhtovar Umarov on 9/11/25.
//

import CoreData
import Combine

final class ProfileRepositoryCoreData: ProfileRepository {
    private let stack: CoreDataStack
    private let mapper: ProfileMapper

    init(stack: CoreDataStack, mapper: ProfileMapper = .init()) {
        self.stack = stack
        self.mapper = mapper
    }

    func saveLocal(_ profile: UserProfile) -> AnyPublisher<Void, Error> {
        let ctx = stack.newBackgroundContext()
        return Future { promise in
            ctx.perform {
                do {
                    let req = ProfileEntity.fetchRequest()
                    if let email = profile.email as String? {
                        req.predicate = NSPredicate(format: "email == %@", email)
                    }
                    let result = try ctx.fetch(req).first ?? ProfileEntity(context: ctx)
                    self.mapper.apply(profile, to: result)
                    try ctx.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    func fetchLocal(byEmail email: String?) -> AnyPublisher<UserProfile?, Never> {
        let ctx = stack.viewContext
        return Future { promise in
            ctx.perform {
                do {
                    let req = ProfileEntity.fetchRequest()
                    if let email, !email.isEmpty {
                        req.predicate = NSPredicate(format: "email == %@", email)
                    }
                    req.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
                    let obj = try ctx.fetch(req).first
                    promise(.success(obj.map(self.mapper.toDomain)))
                } catch {
                    promise(.success(nil))
                }
            }
        }.eraseToAnyPublisher()
    }

    func clearAll() -> AnyPublisher<Void, Error> {
        let ctx = stack.newBackgroundContext()
        return Future { promise in
            ctx.perform {
                do {
                    let req = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileEntity")
                    let del = NSBatchDeleteRequest(fetchRequest: req)
                    try ctx.execute(del)
                    try ctx.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}

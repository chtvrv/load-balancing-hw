import Leaf
import Fluent
import FluentSQLiteDriver
import Vapor
import Metrics

public func configure(_ app: Application) throws {
  app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

  app.views.use(.leaf)
  app.leaf.cache.isEnabled = app.environment.isRelease

  app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

  let modules: [Module] = [
    FrontendModule(),
    BlogModule(),
  ]

  for module in modules {
    try module.configure(app)
  }

  let myProm = PrometheusClient()
  MetricsSystem.bootstrap(myProm)

  app.get("metrics") { req -> EventLoopFuture<String> in
    let promise = req.eventLoop.makePromise(of: String.self)
    try MetricsSystem.prometheus().collect(into: promise)
    return promise.futureResult
  }
}

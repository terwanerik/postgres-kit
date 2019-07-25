/// PostgreSQL specific `SQLFunction`.
public struct PostgreSQLFunction: SQLFunction {
    /// See `SQLFunction`.
    public typealias Argument = GenericSQLFunctionArgument<PostgreSQLExpression>
    
    /// See `SQLFunction`.
    public static func function(_ name: String, _ args: [Argument]) -> PostgreSQLFunction {
        return .init(name: name, arguments: args)
    }
    
    /// See `SQLFunction`.
    public let name: String
    
    /// See `SQLFunction`.
    public let arguments: [Argument]
    
    /// See `SQLSerializable`.
    public func serialize(_ binds: inout [Encodable]) -> String {
        return name + "(" + arguments.map { $0.serialize(&binds) }.joined(separator: ", ") + ")"
    }
}

extension SQLSelectExpression where Expression.Function == PostgreSQLFunction {
    // custom
}

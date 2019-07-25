extension PostgreSQLMessage {
    /// Identifies the message as a Parse command.
    struct ParseRequest {
        /// The name of the destination prepared statement (an empty string selects the unnamed prepared statement).
        var statementName: String
        
        /// The query string to be parsed.
        var query: String
        
        /// The number of parameter data types specified (can be zero).
        /// Note that this is not an indication of the number of parameters that might appear in the
        /// query string, only the number that the frontend wants to prespecify types for.
        /// Specifies the object ID of the parameter data type. Placing a zero here is equivalent to leaving the type unspecified.
        var parameterTypes: [PostgreSQLDataFormat]
    }
}

// MARK: Serialize

extension PostgreSQLMessage.ParseRequest {
    /// Serializes this message into a byte buffer.
    func serialize(into buffer: inout ByteBuffer) {
        buffer.write(nullTerminated: statementName)
        buffer.write(nullTerminated: query)
        buffer.write(array: parameterTypes) { buffer, dataType in
            buffer.write(integer: dataType.raw)
        }
    }
}

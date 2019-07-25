extension PostgreSQLMessage {
    /// Authentication request returned by the server.
    enum AuthenticationRequest {
        /// AuthenticationOk
        /// Specifies that the authentication was successful.
        case ok
        
        /// AuthenticationCleartextPassword
        /// Specifies that a clear-text password is required.
        case plaintext
        
        /// AuthenticationMD5Password
        /// Specifies that an MD5-encrypted password is required.
        case md5(Data)
    }
}

// MARK: String

extension PostgreSQLMessage.AuthenticationRequest: CustomStringConvertible {
    /// See `CustomStringConvertible`.
    var description: String {
        switch self {
        case .ok: return "Ok"
        case .plaintext: return "CleartextPassword"
        case .md5(let salt): return "MD5Password(salt: 0x\(salt.hexEncodedString())"
        }
    }
}

// MARK: Parse

extension PostgreSQLMessage.AuthenticationRequest {
    /// Parses an instance of this message type from a byte buffer.
    static func parse(from buffer: inout ByteBuffer) throws -> PostgreSQLMessage.AuthenticationRequest {
        guard let type = buffer.readInteger(as: Int32.self) else {
            throw PostgreSQLError.protocol(reason: "Could not read authentication message type.")
        }
        switch type {
        case 0: return .ok
        case 3: return .plaintext
        case 5:
            guard let salt = buffer.readData(length: 4) else {
                throw PostgreSQLError.protocol(reason: "Could not parse MD5 salt from authentication message.")
            }
            return .md5(salt)
        default:
            throw PostgreSQLError.protocol(reason: "Unkonwn authentication request type: \(type).")
        }
    }
}

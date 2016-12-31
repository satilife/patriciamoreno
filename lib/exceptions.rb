module Exceptions
  class AuthenticationError         < StandardError; end
    class IdentityExistsError       < AuthenticationError; end

  class AuthorizationError          < StandardError; end
    class PasswordAlreadySetError   < AuthorizationError; end
    class UndeletableRecord         < AuthorizationError; end
end

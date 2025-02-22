# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `RegisterWithingsJob`.
# Please instead update this file by running `bin/tapioca dsl RegisterWithingsJob`.


class RegisterWithingsJob
  class << self
    sig do
      params(
        user_id: T.untyped,
        code: T.untyped,
        state: T.untyped,
        block: T.nilable(T.proc.params(job: RegisterWithingsJob).void)
      ).returns(T.any(RegisterWithingsJob, FalseClass))
    end
    def perform_later(user_id, code, state, &block); end

    sig { params(user_id: T.untyped, code: T.untyped, state: T.untyped).returns(T.untyped) }
    def perform_now(user_id, code, state); end
  end
end

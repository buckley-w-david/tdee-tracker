# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `FetchWithingsJob`.
# Please instead update this file by running `bin/tapioca dsl FetchWithingsJob`.


class FetchWithingsJob
  class << self
    sig do
      params(
        block: T.nilable(T.proc.params(job: FetchWithingsJob).void)
      ).returns(T.any(FetchWithingsJob, FalseClass))
    end
    def perform_later(&block); end

    sig { returns(T.untyped) }
    def perform_now; end
  end
end
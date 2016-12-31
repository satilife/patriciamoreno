class BasePresenter
  def initialize(object, template, user=nil)
    @object = object
    @view = template
    @user = user
  end

  private

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  attr_reader :view, :user
end

module Bouncer
  module GuestList
    module ClassMethods
      
      # defines access to a given resource and action if
      # the given lambda evaluates to true
      #
      # can_access :post do
      #   on :show,   :if => lambda {|post, opts| post.user_name == self.name }
      #   on :create, :if => lambda {|post, opts| post.user_name =~ /admin/ }
      # end
      def can_access resource_name, &block
        @new_resource_name = resource_name
        def on action, opts={}
          bouncer_access_list[@new_resource_name] ||= {}
          bouncer_access_list[@new_resource_name][action] = opts
        end
        yield
      end  
            
      def inherited_attributes(*args)
        @inherited_attributes ||= [:inherited_attributes]
        @inherited_attributes += args
        args.each do |arg|
          class_eval %(
            class << self; attr_accessor :#{arg} end
          )
        end
        @inherited_attributes
      end

      def inherited(subclass)
        @inherited_attributes.each do |inheritable_attribute|
          instance_var = "@#{inheritable_attribute}"
          subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
        end
      end
    end

    module InstanceMethods
      def bouncer_access_list
        self.class.bouncer_access_list
      end
      
      #  @user.can?(:create, @post, {:site => @site})
      def can? action, resource, opts={} 
        resource_actions  = self.bouncer_access_list[resource.class.to_s.downcase.to_sym]
        return false      if resource_actions.nil?

        rule_for_action   = resource_actions[action]
        return false      if rule_for_action.nil?
        
        conditional       = rule_for_action[:if]

        instance_exec resource, opts, &conditional
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods

      receiver.class_eval do
        inherited_attributes :bouncer_access_list
        @bouncer_access_list  = {}
      end
    end
  end
end

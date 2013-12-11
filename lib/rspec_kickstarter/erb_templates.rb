# -*- encoding: utf-8 -*-

require 'erb'
require 'rspec_kickstarter'

#
# ERB templates
#
module RSpecKickstarter::ERBTemplates

  BASIC_METHODS_PART_TEMPLATE = <<SPEC
<%- methods_to_generate.map { |method| %>
  describe '#<%= method.name %>' do
    it 'works' do
<%- unless get_instantiation_code(c, method).nil?      -%><%= get_instantiation_code(c, method) %><%- end -%>
<%- unless get_params_initialization_code(method).nil? -%><%= get_params_initialization_code(method) %><%- end -%>
      result = <%= get_method_invocation_code(c, method) %>
      expect(result).not_to be_nil
    end
  end
<% } %>
SPEC

  BASIC_NEW_SPEC_TEMPLATE = <<SPEC
require 'spec_helper'
<% unless rails_mode then %>require '<%= self_path %>'
<% end -%>

describe <%= get_complete_class_name(c) %> do
<%= ERB.new(BASIC_METHODS_PART_TEMPLATE, nil, '-').result(binding) -%>
end
SPEC

  RAILS_CONTROLLER_METHODS_PART_TEMPLATE = <<SPEC
<%- methods_to_generate.map { |method| %>
  describe '<%= get_rails_http_method(method.name).upcase %> <%= method.name %>' do
    it 'works' do
      <%= get_rails_http_method(method.name) %> :<%= method.name %>, {}, {}
      expect(response.status).to eq(200)
    end
  end
<% } %>
SPEC

  RAILS_CONTROLLER_NEW_SPEC_TEMPLATE = <<SPEC
require 'spec_helper'

describe <%= get_complete_class_name(c) %> do
<%= ERB.new(RAILS_CONTROLLER_METHODS_PART_TEMPLATE, nil, '-').result(binding) -%>
end
SPEC

  RAILS_HELPER_METHODS_PART_TEMPLATE = <<SPEC
<%- methods_to_generate.map { |method| %>
  describe '#<%= method.name %>' do
    it 'works' do
      result = <%= get_rails_helper_method_invocation_code(method) %>
      expect(result).not_to be_nil
    end
  end
<% } %>
SPEC

  RAILS_HELPER_NEW_SPEC_TEMPLATE = <<SPEC
require 'spec_helper'

describe <%= get_complete_class_name(c) %> do
<%= ERB.new(RAILS_HELPER_METHODS_PART_TEMPLATE, nil, '-').result(binding) -%>
end
SPEC

end

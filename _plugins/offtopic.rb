module Jekyll
  module Offtopic
    class OfftopicTag < Liquid::Block
      @@DEFAULTS = {
          :title => 'Подробности',
          :compact => false,
      }

      def self.DEFAULTS
        return @@DEFAULTS
      end

      def initialize(tag_name, markup, tokens)
        super

        @config = {}
        override_config(@@DEFAULTS)

        params = markup.scan /([a-z]+)\=\"(.+?)\"/
        if params.size > 0
          config = {}
          params.each do |param|
            config[param[0].to_sym] = param[1]
          end
          override_config(config)
        end
      end

      def override_config(config)
        config.each{ |key,value| @config[key] = value }
      end

      def render(context)
        content = super

        site_config = context.registers[:site].config
        rendered_content = Jekyll::Converters::Markdown::KramdownParser.new(site_config).convert(content)

        if @config[:compact]
          div_details_class = "details details__compact"
        else
          div_details_class = "details"
        end

        %Q(
<div class="#{div_details_class}">
<a href="javascript:void(0)" class="details__summary">#{@config[:title]}</a>
<div class="details__content" markdown="1">
#{rendered_content}
</div>
</div>
        )
      end
    end
  end
end

Liquid::Template.register_tag('offtopic', Jekyll::Offtopic::OfftopicTag)

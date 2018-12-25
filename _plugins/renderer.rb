require "redcarpet"
require "rouge"
require "rouge/plugins/redcarpet"

class SemanticRender < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
    def image(link, title, alt)
        name = File.basename(link, ".*")
        img = "<img class=\"ui bordered rounded image\" src=\"#{link}\" alt=\"#{alt}\" title=\"#{title}\">"
        figure = "<a href=\"#{link}\" data-lightbox=\"#{name}\" data-title=\"#{alt}\">#{img}</a>"
        caption = title ? "<figcaption>#{title}</figcaption>" : ""
        #return "<figure>#{figure}#{caption}</figure>"
        return "<div class=\"ui compact segment\">
            <div class=\"ui rounded image\">
                <img src=\"#{link}\" alt=\"#{alt}\" title=\"#{title}\">
            </div>
            <div class='ui divider'></div>
            <div class=\"content\">
                <h5 class=\"ui header\">#{title}</h5>
            </div>
        </div>"
    end

    def header(text, header_level)
        return "<h#{header_level} class='ui header'>#{text}</h#{header_level}>"
    end

    def hrule()
        return "<div class='ui divider'></div>"
    end

    def list(contents, list_type)
        return "<div class=\"ui #{list_type == :unordered ? 'bulleted' : 'ordered'} list\">#{contents}</div>"
    end

    def list_item(text, list_type)
        "<div class=\"item\">#{text}</div>"
    end

    def block_quote(quote)
        "<div class=\"ui floating compact message\">#{quote}</div>"
    end

    def block_code(code, language)
        "<div class=\"ui black inverted highlight segment\"><pre><code>#{Rouge.highlight(code, language || 'text', 'html') }</code></pre></div>"
    end
end

class Jekyll::Converters::Markdown::SemanticRender
    def initialize(config)
        @config = config
        options = {
            strikethrough: true,
            no_intra_emphasis: true,
            tables: true,
            space_after_headers: true,
            underline: true,
            footnotes: true,
            fenced_code_blocks: true
        }
        @renderer = Redcarpet::Markdown.new(SemanticRender, options)
    end

    def convert(content)
        @renderer.render(content)
    end
end
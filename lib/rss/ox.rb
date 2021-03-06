require 'rss'

module RSS
  class OxParser < BaseParser
    def self.listener
      OxListener
    end

    private
    def _parse
      Ox.sax_parse(@listener, StringIO.new(@rss), :convert_special => true)
    end
  end

  class OxListener < BaseListener
    include ListenerMixin

    def instruct(target)
      @attr={}
    end

    def end_instruct(target)
      if target == 'xml'
        xmldecl(@attr['version'], nil, @attr['standalone'] == 'yes')
        if @attr['encoding']
          @xml_enc = @attr['encoding']
          @encoding = 'UTF-8'
        end
      else
        content=''
        @attr.each { |k,v| content<<"#{k}=\"#{v}\" " }
        instruction target, content
      end
    end

    def attr(name, str)
      @attr[name.to_s] = str
    end

    def doctype(str); end
    def comment(str); end

    def cdata(str)
      text(str)
    end

    def text(str)
      ensure_start
      str.encode!(@encoding,@xml_enc) if @xml_enc
      super(str)
    end

    def start_element(name)
      ensure_start

      @attr = {}
      @started = name
    end
    def end_element(name)
      ensure_start
      tag_end name
    end

    private
    def ensure_start
      if @started
        tag_start @started, @attr
        @started = nil
      end
    end
  end

  begin
    lib = 'ox'
    require lib
    AVAILABLE_PARSER_LIBRARIES << ['rss/ox', :OxParser]
    AVAILABLE_PARSERS << OxParser
    Parser.default_parser = OxParser
  rescue LoadError
    warn "Couldn't load #{lib}. Falled back to the default parser(#{Parser.default_parser})."
  end
end

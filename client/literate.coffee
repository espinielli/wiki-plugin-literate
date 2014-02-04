escape = (str) ->
  String(str)
    .replace(/&/g, '&amp;')
		.replace(/"/g, '&quot;')
		.replace(/'/g, '&#39;')
		.replace(/</g, '&lt;')
		.replace(/>/g, '&gt;')

class window.plugins.literate
  load = (callback) ->
    wiki.getScript '/plugins/code/prettify.js', callback
    $('<style type="text/css"></style>')
      .html('@import url("/plugins/code/prettify.css")')
      .appendTo("head");

  @emit: (div, item) ->
    load ->
      # extract name and configuration params
      lines = item.text.split "\n"
      config = lines.shift()
      config = JSON.parse(config) # should be a JSON-like line, i.e. {name:"my preferred name", lang:"py", linenum=5}
      config.name = config.name or "*"
      item.name = config.name
      config.lang = config.lang or "text"

      code = lines.join "\n"

      # search whole page for code snippets with this same name
      #...for each count length (for reference too)
      lits = {}
      page = div.parents('.page').data('data')

      for elem in page.story
        if elem.type is 'literate'
          if not lits[elem.name]?
            lits[elem.name] = [elem]
          else
            lits[elem.name].push elem


      # chunk name ala pagefold with hyperlink and anchor
      # ENHANCEMENT: add info about which of the sequence of chunks with the same name this is, i.e. for the third 1,2,*3*,4
      # ENHANCEMENT: current chunk in sequence is bold, the others are links to the relevant ones.
      # ENHANCEMENT: add status about config params, "!!" with tooltip text explaining the problem (OUT param different from
      #              from previous chunks with the same name) === Maybe not useful if creation of code distrib is delegated to
      #              another page (following the pattern of data provision / data consumption) ===
      if lits[item.name][0].id is item.id
        anchor = "id=\"#{wiki.asSlug config.name}\""
      else
        anchor = ""
      anchor += " href=\"#{"#".concat (wiki.asSlug config.name)}\""

      div.append """
        <div class="chunk" style="border: 1px solid lightgray; padding: 3px; border-radius: 5px;">
          <span style="position: relative; top: -15px; left: 10px; background: white; display: inline-block; color: gray; ">
            &nbsp; <a #{anchor}>#{config.name}</a> &nbsp;
          </span>
        </div>
        """
      ;

      codechunk = div.find(".chunk");  # TODO: is there a better way?
      # separate reference and plain code snippets
      chunk = []
      for c in lines
        if m = /^(.*)@\[(.*)\]@(.*)$/g.exec c
          if chunk.length > 0
            codechunk.append """<pre class="prettyprint lang-#{config.lang}" style="margin:0px; padding:0px">#{prettyPrintOne(escape(chunk.join "\n"))}</pre>"""
          codechunk.append """
            <pre class="prettyprint lang-text" style="margin:0px; padding:0px">#{prettyPrintOne(escape(m[1]))}<a href="#{"#".concat (wiki.asSlug m[2])}">@[#{m[2]}]@</a>#{prettyPrintOne(escape(m[3]))}</pre>
            """
          chunk = []
        else
          chunk.push c

      if chunk.length > 0
        codechunk.append """<pre class="prettyprint lang-#{config.lang}" style="margin:0px; padding:0px">#{prettyPrintOne(escape(chunk.join "\n"))}</pre>"""


  @bind: (div, item) ->
    load -> div.dblclick -> wiki.textEditor div, item

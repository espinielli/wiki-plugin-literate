escape = (str) ->
  String(str)
    .replace(/&/g, '&amp;')
		.replace(/"/g, '&quot;')
		.replace(/'/g, '&#39;')
		.replace(/</g, '&lt;')
		.replace(/>/g, '&gt;')


parse = (text) ->
  chunk = {name: "*", lang: "text", code: []}

  lines = text.text.split /\n/
  index = 0

  words = lines[0].match /\S+/g
  if words is null or words.length < 1
      # ignore it
  else if words[0] is 'NAME'
    chunk.name = "#{(words[1..].join ' ').trim()}"
    index = 1
    words = lines[1].match /\S+/g
    if words is null or words.length < 1
      # ignore it
    else if words[0] is 'LANG'
        chunk.lang = "#{(words[1..].join ' ').trim()}"
        index = 2

  chunk.code = lines[index..]
  chunk


class window.plugins.literate
  load = (callback) ->
    wiki.getScript '/plugins/code/prettify.js', callback
    $('<style type="text/css"></style>')
      .html('@import url("/plugins/code/prettify.css")')
      .appendTo("head");

  @emit: (div, item) ->
    load ->
      # extract name and configuration params
      chunk = parse item
      item.name = chunk.name

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
        anchor = "id=\"#{wiki.asSlug chunk.name}\""
      else
        anchor = ""
      anchor += " href=\"#{"#".concat (wiki.asSlug chunk.name)}\""

      div.append (codechunk = $ """
        <div class="chunk" style="border: 1px solid gray; margin: 16px 16px; padding: 3px; border-radius: 5px;">
          <span style="position: relative; top: -15px; left: 10px; background: white; display: inline-block; color: gray; ">
            &nbsp; <a #{anchor}>#{chunk.name}</a> &nbsp;
          </span>
        </div>
        """)

      # separate reference and plain code snippets
      temp = []
      for c in chunk.code
        if m = /^(.*)@\[(.*)\]@(.*)$/g.exec c
          if temp.length > 0
            codechunk.append """<pre class="prettyprint lang-#{chunk.lang}" style="margin:0px; padding:0px; position: relative; top: -8px">#{prettyPrintOne(escape(temp.join "\n"))}</pre>"""
          codechunk.append """
            <pre class="prettyprint lang-text" style="margin:0px; padding:0px; position: relative; top: -8px">#{prettyPrintOne(escape(m[1]))}<a href="#{"#".concat (wiki.asSlug m[2])}">@[#{m[2]}]@</a>#{prettyPrintOne(escape(m[3]))}</pre>
            """
          temp = []
        else
          temp.push c

      if temp.length > 0
        codechunk.append """<pre class="prettyprint lang-#{chunk.lang}" style="margin:0px; padding:0px; position: relative; top: -8px">#{prettyPrintOne(escape(chunk.code.join "\n"))}</pre>"""


  @bind: (div, item) ->
    load -> div.dblclick -> wiki.textEditor div, item

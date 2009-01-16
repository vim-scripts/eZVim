" Vim syntax file
" Language:	eZ Publish Templates
" Maintainer:   damien pobel dpobel@free.fr
" Last Change:  Mon Jan  13 12:11:23 CET 2009
" Filenames:    *.tpl
" URL:		http://projects.ez.no/ezvim

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
  finish
endif
  let main_syntax = 'ezp'
endif

syn case ignore

runtime! syntax/html.vim

" needed to recognize cache-block, set-block, $node, ...
set isk+=-
set isk+=$

syn keyword ezpTagName include
syn keyword ezpTagName attribute_edit_gui
syn keyword ezpTagName attribute_pdf_gui
syn keyword ezpTagName attribute_result_gui
syn keyword ezpTagName attribute_view_gui
syn keyword ezpTagName class_attribute_edit_gui
syn keyword ezpTagName class_attribute_view_gui
syn keyword ezpTagName collaboration_icon
syn keyword ezpTagName collaboration_participation_view
syn keyword ezpTagName collaboration_simple_message_view
syn keyword ezpTagName collaboration_view_gui
syn keyword ezpTagName content_pdf_gui
syn keyword ezpTagName content_version_view_gui
syn keyword ezpTagName content_view_gui
syn keyword ezpTagName event_edit_gui
syn keyword ezpTagName node_view_gui
syn keyword ezpTagName related_view_gui
syn keyword ezpTagName shop_account_view_gui
syn keyword ezpTagName tool_bar

syn keyword ezpTagName if elseif else ldelim rdelim literal
syn keyword ezpTagName section foreach section-else
syn keyword ezpTagName switch case
syn keyword ezpTagName fetch cache-block set-block append-block

syn keyword ezpModifier upper wordwrap concat simplify trim shorten autolink
syn keyword ezpModifier explode extract_right begins_with
syn keyword ezpModifier wash ezurl ezdesign ezimage ezroot datetime
syn keyword ezpModifier true false is_set def set undef default l10n i18n si let set
syn keyword ezpModifier hash array ezini
syn keyword ezpModifier merge "contains" append array array_sum compare
syn keyword ezpModifier ends_with explode extract extract_left
syn keyword ezpModifier implode prepend remove repeat reverse unique

syn keyword ezpModifier currentdate
syn keyword ezpModifier ezhttp
syn keyword ezpModifier ezhttp_hasvariable
syn keyword ezpModifier ezini_hasvariable
syn keyword ezpModifier ezmodule
syn keyword ezpModifier ezpreference
syn keyword ezpModifier ezsys
syn keyword ezpModifier module_params

syn keyword ezpModifier image
syn keyword ezpModifier imagefile
syn keyword ezpModifier texttoimage
syn keyword ezpModifier and
syn keyword ezpModifier choose
syn keyword ezpModifier cond
syn keyword ezpModifier eq
syn keyword ezpModifier false
syn keyword ezpModifier first_set
syn keyword ezpModifier ge
syn keyword ezpModifier gt
syn keyword ezpModifier le
syn keyword ezpModifier lt
syn keyword ezpModifier ne
syn keyword ezpModifier not
syn keyword ezpModifier null
syn keyword ezpModifier or
syn keyword ezpModifier true

syn keyword ezpModifier abs
syn keyword ezpModifier ceil
syn keyword ezpModifier dec
syn keyword ezpModifier div
syn keyword ezpModifier floor
syn keyword ezpModifier inc
syn keyword ezpModifier max
syn keyword ezpModifier min
syn keyword ezpModifier mod
syn keyword ezpModifier mul
syn keyword ezpModifier rand
syn keyword ezpModifier round
syn keyword ezpModifier sub
syn keyword ezpModifier sum

syn keyword ezpModifier action_icon
syn keyword ezpModifier attribute
syn keyword ezpModifier classgroup_icon
syn keyword ezpModifier class_icon
syn keyword ezpModifier content_structure_tree
syn keyword ezpModifier ezpackage
syn keyword ezpModifier flag_icon
syn keyword ezpModifier gettime
syn keyword ezpModifier icon_info
syn keyword ezpModifier makedate
syn keyword ezpModifier maketime
syn keyword ezpModifier mimetype_icon
syn keyword ezpModifier month_overview
syn keyword ezpModifier pdf
syn keyword ezpModifier roman
syn keyword ezpModifier topmenu
syn keyword ezpModifier treemenu

syn keyword ezpModifier append
syn keyword ezpModifier autolink
syn keyword ezpModifier begins_with
syn keyword ezpModifier break
syn keyword ezpModifier chr
syn keyword ezpModifier compare
syn keyword ezpModifier concat
syn keyword ezpModifier contains
syn keyword ezpModifier count_chars
syn keyword ezpModifier count_words
syn keyword ezpModifier crc32
syn keyword ezpModifier downcase
syn keyword ezpModifier ends_with
syn keyword ezpModifier explode
syn keyword ezpModifier extract
syn keyword ezpModifier extract left
syn keyword ezpModifier extract_right
syn keyword ezpModifier indent
syn keyword ezpModifier insert
syn keyword ezpModifier md5
syn keyword ezpModifier nl2br
syn keyword ezpModifier ord
syn keyword ezpModifier pad
syn keyword ezpModifier prepend
syn keyword ezpModifier remove
syn keyword ezpModifier repeat
syn keyword ezpModifier reverse
syn keyword ezpModifier rot13
syn keyword ezpModifier shorten
syn keyword ezpModifier simpletags
syn keyword ezpModifier simplify
syn keyword ezpModifier trim
syn keyword ezpModifier upcase
syn keyword ezpModifier upfirst
syn keyword ezpModifier upword
syn keyword ezpModifier wash
syn keyword ezpModifier wordtoimage
syn keyword ezpModifier wrap

syn keyword ezpModifier count
syn keyword ezpModifier float
syn keyword ezpModifier get_class
syn keyword ezpModifier get_type
syn keyword ezpModifier int
syn keyword ezpModifier is_array
syn keyword ezpModifier is_boolean
syn keyword ezpModifier is_class
syn keyword ezpModifier is_float
syn keyword ezpModifier is_integer
syn keyword ezpModifier is_null
syn keyword ezpModifier is_numeric
syn keyword ezpModifier is_object
syn keyword ezpModifier is_set
syn keyword ezpModifier is_string
syn keyword ezpModifier is_unset

syn keyword ezpDot .

syn region ezpZone matchgroup=Delimiter start="{" end="}" contains=ezpBlock, ezpTagName, ezpInFunc, ezpModifier
syn region ezpComment matchgroup=Delimiter start="{\*\**" end="\**\*}"
syn region ezpLiteral matchgroup=Delimiter start="{literal}" end="{/literal}"

syn region ezpString start=+"+ end=+"+ containedin=ezpZone,ezpModifier
syn region ezpString start="'" end="'" containedin=ezpZone,ezpModifier

syn match ezpVariables "\$[^ |}]*" containedin=ezpZone
syn match ezpSpecialVariables "\$node[^ |}]*" containedin=ezpZone
syn match ezpSpecialVariables "\$module_result[^ |}]*" containedin=ezpZone
syn match ezpSpecialVariables "\$view_parameters[^ |}]*" containedin=ezpZone

syn region  htmlString   contained start=+"+ end=+"+ contains=htmlSpecialChar,javaScriptExpression,@htmlPreproc,ezpZone
syn region  htmlString   contained start=+'+ end=+'+ contains=htmlSpecialChar,javaScriptExpression,@htmlPreproc,ezpZone
syn region htmlLink start="<a\>\_[^>]*\<href\>" end="</a>"me=e-4 contains=@Spell,htmlTag,htmlEndTag,htmlSpecialChar,htmlPreProc,htmlComment,javaScript,@htmlPreproc,ezpZone

" to avoid special colors in <head></head> section
syn clear htmlHead

syn clear cssStyle
syn region cssStyle start=+<style+ keepend end=+</style>+ contains=@htmlCss,htmlTag,htmlEndTag,htmlCssStyleComment,@htmlPreproc,ezpZone

if version >= 508 || !exists("did_ezp_syn_inits")
  if version < 508
    let did_ezp_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  if !exists('ezp_my_rendering')
      hi def ezpStyleVariable        term=bold cterm=bold gui=bold
      hi def ezpStyleSpecialVariable term=bold cterm=bold gui=bold
  endif

  HiLink ezpTagName Identifier
  HiLink ezpProperty Constant
  HiLink ezpLiteral PreProc
  HiLink ezpInFunc Function
  HiLink ezpBlock Constant
  HiLink ezpDot SpecialChar
  HiLink ezpModifier Function
  HiLink ezpComment PreProc
  " Uncomment to make all variables in bold
  "HiLink ezpVariables ezpStyleVariable
  HiLink ezpSpecialVariables ezpStyleSpecialVariable
  " Uncomment to make all string colored
  "HiLink ezpString String
  delcommand HiLink
endif

let b:current_syntax = "ezp"

if main_syntax == 'ezp'
  unlet main_syntax
endif

" vim: ts=4

" This file is part of ezvim.
"
" Authors :
"   Damien Pobel <dpobel@free.fr>
"
" ezvim is free software; you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation; either version 2 of the License, or
" (at your option) any later version.
" 
" ezvim is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
" 
" You should have received a copy of the GNU General Public License
" along with ezvim; if not, write to the Free Software
" Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA



" Default config
if !exists('EzSideBarWidth')
    let EzSideBarWidth = 42
endif
if !exists('EzBrowser')
    let EzBrowser='firefox'
endif

let EzSideBarName="ezbar"
let EzAttributeDocBase="http://ez.no/doc/content/advancedsearch?&SearchText="
let EzDocumentation="http://ez.no/doc/ez_publish/technical_manual/3_8"
let EzClassesGroupView="/class/classlist/"
let EzClassesGroupEdit="/class/groupedit/"
let EzClassView="/class/view/"
let EzClassEdit="/class/edit/"

" Abbreviations for template
autocmd BufNewFile,BufRead *.tpl call EzTplEnvironment()

" Classes View
command! -nargs=1 -bar Ezcv call Ezcv('<args>')
abbreviate cv Ezcv

pyf ~/.vim/plugin/ez.py
function! Ezcv(siteurl)
    let winnum = bufwinnr(g:EzSideBarName)
    let python_func = 'py eZClassesView("'.a:siteurl.'")'
    if winnum != -1
        " windows already exists, just refresh
        exec winnum . 'wincmd w'
        exec python_func
        return
    endif
    let bufnum = bufnr(g:EzSideBarName)
    if bufnum == -1
        " no buffer for classes view, creating one
        badd g:EzSideBarName
    endif
    exe 'silent! topleft vertical '.g:EzSideBarWidth.' split +0 '.g:EzSideBarName
    set buftype=nofile
    set bufhidden=hide
    set noswapfile
    setlocal nowrap
    setlocal nonumber
    setlocal filetype=g:EzSideBarName
    setlocal foldmethod=manual
    setlocal foldtext=v:folddashes.substitute(getline(v:foldstart),'\ \ ','','g')
    if has('gui_running')
        " dont need foldcolumn in a terminal
        setlocal foldcolumn=3
    endif

    " Highligthing data
    syntax match ezClassGroup '^[^ ][A-Z0-9a-z]* '
    syntax match ezClassViewTitle /^Site:.*/
	syntax match ezError /^Error:.*$/
    syntax region ezClassIdentifier start="o .* \[" end="\["
    syntax region ezStringIdentifier start="\["hs=e+1 end="\]"he=s-1
    syntax region ezClassName start="  o "hs=e+1 end=" #"he=s-1
    syntax region ezRequired start="+ "hs=e+1 end=" "he=s-1
    highlight default link ezClassGroup Title
    highlight default link ezClassName PreProc
    highlight default link ezClassIdentifier PreProc
    highlight default link ezStringIdentifier Type
    highlight default link ezRequired Special
	highlight default link ezError Error

    " Simplier keybindings
    nnoremap <buffer> <silent> + :silent! foldopen<CR>
    nnoremap <buffer> <silent> - :silent! foldclose<CR>
    nnoremap <buffer> <silent> * :silent! %foldopen!<CR>
    nnoremap <buffer> <silent> = :silent! %foldclose<CR>
    nnoremap <buffer> <silent> d :call OpenEzDoc()<CR>
    nnoremap <buffer> <silent> e :call OpenEzEdit()<CR>
    nnoremap <buffer> <silent> v :call OpenEzView()<CR>
    
    exec python_func
endfunction

function! GetSiteURL()
    return substitute(getline(1), 'Site\: ', '', '')
endfunction

function! OpenEzViewEdit()
    if !exists('*system') || !executable(g:EzBrowser)
        return 
    endif
    if match(getline('.'), '^[^ ]') != -1
        let siteURL = GetSiteURL()
        let id=substitute(getline('.'), '.* \#\([0-9]*\) .*', '\1', '')
        let url = siteURL.g:EzClassesGroupView.id
        let cmd = g:EzBrowser.' "'.url.'"'
        let res = system(cmd)
    elseif match(getline('.'), '^  o ') != -1
        let siteURL = GetSiteURL()
        let id=substitute(getline('.'), '.* \#\([0-9]*\) .*', '\1', '')
        let url = siteURL.g:EzClassView.id
        let cmd = g:EzBrowser.' "'.url.'"'
        let res = system(cmd)
    endif
endfunction

function! OpenEzEdit()
    if !exists('*system') || !executable(g:EzBrowser)
        return 
    endif
    if match(getline('.'), '^[^ ]') != -1
        let siteURL = GetSiteURL()
        let id=substitute(getline('.'), '.* \#\([0-9]*\) .*', '\1', '')
        let url = siteURL.g:EzClassesGroupEdit.id
        let cmd = g:EzBrowser.' "'.url.'"'
        let res = system(cmd)
    elseif match(getline('.'), '^  o ') != -1
        let siteURL = GetSiteURL()
        let id=substitute(getline('.'), '.* \#\([0-9]*\) .*', '\1', '')
        let url = siteURL.g:EzClassEdit.id
        let cmd = g:EzBrowser.' "'.url.'"'
        let res = system(cmd)
    endif
endfunction

function! OpenEzDoc()
    if !exists('*system') || !executable(g:EzBrowser)
        return 
    endif
    if match(getline('.'), '^    [+-] ') != -1   
        let type=substitute(getline('.'), '.*\[\(.*\)\].*', '\1', '')
        let url=g:EzAttributeDocBase . type
    else
        let url=g:EzDocumentation
    endif
    let cmd= g:EzBrowser.' "'.url.'"'
    let res = system(cmd)
endfunction


function! EzTplEnvironment()
	"""""""""" Control structures
    match Error / __ /
	iabbrev ezfe {foreach __ as $k => $val}<CR><CR>{/foreach}
	iabbrev ezfes {foreach __ as $k => $val sequence array( __ ) as $seq}<CR><CR>{/foreach}

	"""""""""" Fetch
	iabbrev ezfcn fetch(content, node, hash('node_id' , __ ))<ESC>4h

	" content list
	iabbrev ezfcl fetch(content, list, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfcls fetch(content, list, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'sort_by', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfcla fetch(content, list, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'attribute_filter', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfclas fetch(content, list, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'sort_by', array( __ ),<CR>'attribute_filter', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfclsa fetch(content, list, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'sort_by', array( __ ),<CR>'attribute_filter', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))

	" content list_count
	iabbrev ezfclc fetch(content, list_count, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfclca fetch(content, list_count, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'attribute_filter', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))

	" content tree
	iabbrev ezfct fetch(content, tree, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfcts fetch(content, tree, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'sort_by', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfcta fetch(content, tree, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'attribute_filter', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfctas fetch(content, tree, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'sort_by', array( __ ),<CR>'attribute_filter', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfctsa fetch(content, tree, hash('parent_node_id', __ ,<CR>'class_filter_type', include,<CR>'class_filter_array', array( __ ),<CR>'sort_by', array( __ ),<CR>'attribute_filter', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))

	" content tree_count
	iabbrev ezfctc fetch(content, tree_count, hash('parent_node_id', __ ,<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))
	iabbrev ezfctca fetch(content, tree_count, hash('parent_node_id', __ ,<CR>'attribute_filter', array( __ ),<CR>'offset', $view_paremeters.offset,<CR>'limit', __ ))

endfunction





" TODO
"command! -nargs=0 -bar Eztc call EzTemplateCheck()
"function! EzTemplateCheck()
"    let bufnum = bufnr(g:EzSideBarName)
"    if bufnum == -1
"        " no sidebar buffer, can't guess the URL
"		echoerr 'No sidebar buffer, use load Classes View first'
"		return
"    endif
"	let python_func = 'py eZTemplateCheck('.bufnum.')'
"	exec python_func
"endfunction




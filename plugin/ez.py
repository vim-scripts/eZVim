# This file is part of ezvim.
#
# Authors :
#   Damien Pobel <dpobel@free.fr>
#
# ezvim is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# ezvim is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with ezvim; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

import urllib
import urllib2
import vim
import xml.dom.minidom

#def eZTemplateCheck(ezbarNr):
#    tpl = vim.current.buffer.name
#    barbuf = vim.buffers[ezbarNr-1]
#    first_line = barbuf[0]
#    eztcurl = first_line.replace('Site: ', '')+'/smileclasses/checktemplate'
#    doc = eZLoadXML(eztcurl, {'template':tpl}, None, '')

def eZClassesView(ezsite):
    ezcvurl = ezsite + '/devtools/classes'
    curbuf = vim.current.buffer
    curbuf[:] = None
    curbuf[0] = "Site: "+ezsite
    curbuf.append('')
    doc = eZLoadXML(ezcvurl, '', curbuf, "Classes View")
    if not doc:
        return
	
    for group in doc.getElementsByTagName('group'):
        class_list = group.getElementsByTagName('class')
        group_id = group.getAttribute('id')
        group_txt = eZClassesGroupText(group, class_list)
        group_start_line = len(curbuf)+1
        curbuf.append(group_txt)
        for cl in class_list:
            class_txt = eZClassText(cl)
            class_start_line = len(curbuf)+1
            curbuf.append('  o ' + class_txt)
            for attr in cl.getElementsByTagName('attribute'):
                attr_txt = eZAttributeClass(attr)
                curbuf.append(attr_txt)
            class_end_line = len(curbuf)
            eZDoCommandRange(class_start_line, class_end_line, 'fold')
        group_end_line = len(curbuf)
        curbuf.append('')
        eZDoCommandRange(group_start_line, group_end_line, 'fold')
        # open fold group 1 (Content)
        if int(group_id) == 1 :
            eZDoCommandRange(group_start_line, group_end_line, 'foldopen')
    curbuf.append('')


# Format the line for a Classes Group
def eZClassesGroupText(group, class_list):
    group_id = group.getAttribute('id')
    group_txt = str(group.getAttribute('identifier'))+' #'
    group_txt = group_txt+str(group_id)+' ('+str(len(class_list))
    group_txt = group_txt+' classes)'
    return group_txt

# Format the line for a class
def eZClassText(cl):
    class_name = cl.getAttribute('name')
    class_identifier = cl.getAttribute('identifier')
    class_numeric_id = cl.getAttribute('id')
    class_txt = str(class_name) +' #'+str(class_numeric_id)
    class_txt = class_txt+' ['+str(class_identifier)+']'
    return class_txt
 
# Format the line for an attribute
def eZAttributeClass(attr):
    attr_name = attr.getAttribute('name')
    attr_id = attr.getAttribute('identifier')
    attr_numeric_id = attr.getAttribute('id')
    attr_type = attr.getAttribute('type')
    attr_required = int(attr.getAttribute('is_required'))==1
    attr_prefix = '-'
    if attr_required :
        attr_prefix = '+'
    attr_txt = '    '+attr_prefix+' '+str(attr_id)+' '
    attr_txt = attr_txt+str(attr_name)+' #'+str(attr_numeric_id)
    attr_txt = attr_txt+' ['+str(attr_type)+']'
    return attr_txt



# Launch a vim command on a range of lines
def eZDoCommandRange(start, end, command):
    command = ':'+str(start)+','+str(end)+command
    vim.command(command)
    
# Try to load XML
def eZLoadXML(url, params, buffer, name):
    try:
        p = urllib.urlencode(params)
        u = urllib2.urlopen(url, p)
        r = u.read()
        doc = xml.dom.minidom.parseString(r)
        return doc
    except (Exception, IOError), e:
        msg = "Error: Can't load XML for "+name
        if buffer:
            buffer.append(msg)
        else:
            print msg
    return None



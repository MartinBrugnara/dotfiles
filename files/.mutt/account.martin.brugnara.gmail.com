set imap_user = "martin.brugnara@gmail.com"
set imap_pass = $my_gmail_imap_pass
set smtp_url = "smtp://martin.brugnara@gmail.com@smtp.gmail.com:587/"
set smtp_pass = $my_gmail_imap_pass
set from = "martin.brugnara@gmail.com"
set realname = "Martin Brugnara"
set folder = "imaps://imap.gmail.com:993"
set spoolfile = "+INBOX"
set postponed = "+[Gmail]/Drafts"
set header_cache = ~/.mutt-cache/gmail/cache/headers
set message_cachedir = ~/.mutt-cache/gmail/cache/bodies
set certificate_file = ~/.mutt-cache/gmail/certificates
unset record

set signature ="~/.mutt/gmail.signature"
macro index,pager <f5> '<enter-command>set from="martin.brugnara@gmail.com"<enter><enter-command>set signature ="~/.mutt/gmail.signature"<enter>'
macro index,pager <f6> '<enter-command>set from="martin@campingpuntaindiani.it"<enter><enter-command>set signature ="~/.mutt/cpi.signature"<enter>'
macro index,pager <f7> '<enter-command>set from="hkmartinb1993@gmail.com"<enter><enter-command>set signature ="~/.mutt/gmail.signature"<enter>'

color status brightwhite green

# vim: filetype=muttrc

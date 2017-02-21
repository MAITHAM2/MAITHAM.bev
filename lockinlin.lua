do
local function pre_process(msg)

    local inline = 'mate:'..msg.to.id
    if msg.text == '[unsupported]' and redis:get(inline) and not is_momod(msg) then
            delete_msg(msg.id, ok_cb, true)
end
    return msg
    end
    
 local function keeper(msg, matches)
if is_momod(msg) and matches[1] == "قفل" and matches[2] == "الانلاين" then
local inline = 'mate:'..msg.to.id
redis:set(inline, true)
return  'تـــم #قفــــل|🔐|الانلايـن فــي هــذه المجموعـــــــــةة❤️❗️\n🔲♦️Us : @'..msg.from.username..'\n🔲♦️ID : '.. msg.from.id..'\n'
end
if is_momod(msg) and matches[1] == "فتح" and matches[2] == "الانلاين" then
    local inline = 'mate:'..msg.to.id
    redis:del(inline)
    return 'تـــم #فتـح|🔐|الانلاين فــي هــذه المجموعـــــــــةة❤️❗️\n🔲♦️Us : @'..msg.from.username..'\n🔲♦️ID : '.. msg.from.id..'\n' 
  end
end
return {
    patterns ={
        '^(قفل) (الانلاين)$',
        '^(فتح) (الانلاين)$',
        '^[#!/](قفل) (الانلاين)$',
        '^[#!/](فتح) (الانلاين)$',
    },
run = keeper,
pre_process = pre_process 
}
end
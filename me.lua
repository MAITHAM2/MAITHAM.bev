do 
local function run(msg, matches) 
 if is_sudo(msg) then 
   local sudo = "نورتْ عزيزي👨🏽‍💼 هنـــــا موقعـــــك🍾🍷"..msg.from.first_name.."\n" 
   .."|🦁| ايديـــــــــك👨🏿‍💻 :("..msg.from.id..")\n" 
   .."|🦁| ايــــــدي المجموٌعـــــــةة💋 :("..msg.to.id..")\n" 
   .."|🦁| معرفـــك تاج راســــ🕴🏾ـــي❤️❗️ :(@"..(msg.from.username or "لا يـوجد")..")\n" 
   .."|🦁| رقمــك يروحــٰـٰـي💔😉 :("..(msg.from.phone or " لا يوجد")..")\n" 
   .."|🦁| موقعــــك حبيبي : انت مطوريْ العزيز🕵👋 " 
return reply_msg(msg.id, sudo, ok_cb, true) 
 end 
 if is_owner(msg) then 
 local owner = "نورتْ عزيزي👨🏽‍💼 هنـــــا موقعـــــك🍾🍷"..msg.from.first_name.."\n" 
   .."|🐯| ايديـــــــــك👨🏿‍💻 :("..msg.from.id..")\n" 
   .."|🐯| ايــــــدي المجموٌعـــــــةة💋 :("..msg.to.id..")\n" 
   .."|🐯| معرفـــك تاج راســــ🕴🏾ـــي❤️❗️ :(@"..(msg.from.username or "لا يوجد")..")\n" 
   .."|🐯| رقمــك يروحــٰـٰـي💔😉 :("..(msg.from.phone or " لا يوجد ")..")\n" 
   .."|🐯| موقعــــك حبيبي : انت مديرهم  🚨 👥 »" 
return reply_msg(msg.id, owner, ok_cb, true) 
 end 
 if is_admin1(msg) then 
local admin1 = "نورتْ عزيزي👨🏽‍💼 هنـــــا موقعـــــك🍾🍷" 
   .."|🦊| ايديـــــــــك👨🏿‍💻 :("..msg.from.id..")\n" 
   .."|🦊| ايــــــدي المجموٌعـــــــةة💋 :("..msg.to.id..")\n" 
   .."|🦊| معرفـــك تاج راســــ🕴🏾ـــي❤️❗️ :(@"..(msg.from.username or "لا يوجد")..")\n" 
   .."|🦊| رقمــك يروحــٰـٰـي💔😉 :("..(msg.from.phone or " لايوجد ")..")\n" 
   .."|🦊| موقعــــك آنہتہ اداريْ❤️ 🙋» " 
return reply_msg(msg.id, admin1, ok_cb, true) 
end 
if is_momod(msg) then 
      local admin = "نورتْ عزيزي👨🏽‍💼 هنـــــا موقعـــــك🍾🍷" ..msg.from.first_name.. "\n" 
   .."|🐱| ايديـــــــــك👨🏿‍💻 :("..msg.from.id..")\n" 
   .."|🐱| ايــــــدي المجموٌعـــــــةة💋 :("..msg.to.id..")\n" 
   .."|🐱| معرفـــك تاج راســــ🕴🏾ـــي❤️❗️ :(@"..(msg.from.username or "لا يوجد")..")\n" 
   .."|🐱| رقمــك يروحــٰـٰـي💔😉 :("..(msg.from.phone or " لا يوجد ")..")\n" 
   .."|🐱| موقعـــك آنہتہ الادمـــن ☻😘" 
return reply_msg(msg.id, admin, ok_cb, true) 
 end 
 if not is_momod(msg) then 
      local member = "نورتْ عزيزي👨🏽‍💼 هنـــــا موقعـــــك🍾🍷" ..msg.from.first_name.. "\n" 
   .."|🦋| ايديـــــــــك👨🏿‍💻 :("..msg.from.id..")\n" 
   .."|🦋| ايــــــدي المجموٌعـــــــةة💋 :("..msg.to.id..")\n" 
   .."|🦋| معرفـــك تاج راســــ🕴🏾ـــي❤️❗️ :(@"..(msg.from.username or "لا يوجد")..")\n" 
   .."|🦋| رقمــك يروحــٰـٰـي💔😉 :("..(msg.from.phone or "لايوجد " )..")\n" 
   .."|🦋| موقعُـك: انت عظـــو لا تحـــل ولا ترًبــــط 💔❗️ " 
return reply_msg(msg.id, member, ok_cb, true) 
 end 
end 

return { 
  patterns = { 
       "^(موقعي)$", 
  }, 
  run = run, 
} 
end
----by @llX8Xll

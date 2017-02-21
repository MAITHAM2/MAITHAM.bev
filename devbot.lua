
do 
-- Will leave the group if be added 
local function run(msg, matches) 
local bot_id = our_id 
local receiver = get_receiver(msg) 
    if matches[1] == 'leave' and is_admin1(msg) then 
       chat_del_user("chat#id"..msg.to.id, 'user#id'..bot_id, ok_cb, false) 
      leave_channel(receiver, ok_cb, false) 
    elseif msg.service and msg.action.type == "chat_add_user" and msg.action.user.id == tonumber(bot_id) and not is_admin1(msg) then 
       send_large_msg(receiver, 'إنـــت ❤️ لســت مطـوري لا يمكــنك |💋|اضافتــي لمجموعـــتك يله جــاو✋️🚶', ok_cb, false) 
       chat_del_user(receiver, 'user#id'..bot_id, ok_cb, false) 
      leave_channel(receiver, ok_cb, false) 
    end 
end 
return { 
  patterns = { 
    "^(leave)$", 
    "^!!tgservice (.+)$", 
  }, 
  run = run 
} 
end 
---by @llX8Xll

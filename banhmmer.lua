local function pre_process(msg)
  local data = load_data(_config.moderation.data)
  -- SERVICE MESSAGE
  if msg.action and msg.action.type then
    local action = msg.action.type
    -- Check if banned user joins chat by link
    if action == 'chat_add_user_link' then
      local user_id = msg.from.id
      print('Checking invited user '..user_id)
      local banned = is_banned(user_id, msg.to.id)
      if banned or is_gbanned(user_id) then -- Check it with redis
      print('User is banned!')
      local print_name = user_print_name(msg.from):gsub("‮", "")
   local name = print_name:gsub("_", "")
      savelog(msg.to.id, name.." ["..msg.from.id.."] is banned and kicked ! ")-- Save to logs
      kick_user(user_id, msg.to.id)
      end
    end
    -- Check if banned user joins chat
    if action == 'chat_add_user' then
      local user_id = msg.action.user.id
      print('Checking invited user '..user_id)
      local banned = is_banned(user_id, msg.to.id)
      if banned and not is_momod2(msg.from.id, msg.to.id) or is_gbanned(user_id) and not is_admin2(msg.from.id) then -- Check it with redis
        print('User is banned!')
      local print_name = user_print_name(msg.from):gsub("‮", "")
   local name = print_name:gsub("_", "")
        savelog(msg.to.id, name.." ["..msg.from.id.."] added a banned user >"..msg.action.user.id)-- Save to logs
        kick_user(user_id, msg.to.id)
        local banhash = 'addedbanuser:'..msg.to.id..':'..msg.from.id
        redis:incr(banhash)
        local banhash = 'addedbanuser:'..msg.to.id..':'..msg.from.id
        local banaddredis = redis:get(banhash)
        if banaddredis then
          if tonumber(banaddredis) >= 4 and not is_owner(msg) then
            kick_user(msg.from.id, msg.to.id)-- Kick user who adds ban ppl more than 3 times
          end
          if tonumber(banaddredis) >=  8 and not is_owner(msg) then
            ban_user(msg.from.id, msg.to.id)-- Kick user who adds ban ppl more than 7 times
            local banhash = 'addedbanuser:'..msg.to.id..':'..msg.from.id
            redis:set(banhash, 0)-- Reset the Counter
          end
        end
      end
     if data[tostring(msg.to.id)] then
       if data[tostring(msg.to.id)]['settings'] then
         if data[tostring(msg.to.id)]['settings']['lock_bots'] then
           bots_protection = data[tostring(msg.to.id)]['settings']['lock_bots']
          end
        end
      end
    if msg.action.user.username ~= nil then
      if string.sub(msg.action.user.username:lower(), -3) == 'bot' and not is_momod(msg) and bots_protection == "yes" then --- Will kick bots added by normal users
          local print_name = user_print_name(msg.from):gsub("‮", "")
    local name = print_name:gsub("_", "")
          savelog(msg.to.id, name.." ["..msg.from.id.."] added a bot > @".. msg.action.user.username)-- Save to logs
          kick_user(msg.action.user.id, msg.to.id)
      end
    end
  end
    -- No further checks
  return msg
  end
  -- banned user is talking !
  if msg.to.type == 'chat' or msg.to.type == 'channel' then
    local group = msg.to.id
    local texttext = 'groups'
    --if not data[tostring(texttext)][tostring(msg.to.id)] and not is_realm(msg) then -- Check if this group is one of my groups or not
    --chat_del_user('chat#id'..msg.to.id,'user#id'..our_id,ok_cb,false)
    --return
    --end
    local user_id = msg.from.id
    local chat_id = msg.to.id
    local banned = is_banned(user_id, chat_id)
    if banned or is_gbanned(user_id) then -- Check it with redis
      print('Banned user talking!')
      local print_name = user_print_name(msg.from):gsub("‮", "")
   local name = print_name:gsub("_", "")
      savelog(msg.to.id, name.." ["..msg.from.id.."] banned user is talking !")-- Save to logs
      kick_user(user_id, chat_id)
      msg.text = ''
    end
  end
  return msg
end

local function kick_ban_res(extra, success, result)
      local chat_id = extra.chat_id
   local chat_type = extra.chat_type
   if chat_type == "chat" then
  receiver = 'chat#id'..chat_id
   else
  receiver = 'channel#id'..chat_id
   end
   if success== 0 then
  return send_large_msg(receiver, "Cannot find user by that username!")
   end
      local member_id = result.peer_id
      local user_id = member_id
      local member = result.username
   local from_id = extra.from_id
      local get_cmd = extra.get_cmd
       if get_cmd == "زحلكه" then
         if member_id == from_id then
            send_large_msg(receiver, "لآ يمكنـــــك 🗣حظــر نفســـك♥️❗️")
   return
         end
         if is_momod2(member_id, chat_id) and not is_admin2(sender) then
            send_large_msg(receiver, "لآ يمكنـــــك🖐🏽 حظـٰر الادمـــن آؤ المديــــــر♥️❗️")
   return
         end
   kick_user(member_id, chat_id)
      elseif get_cmd == 'حظر' then
        if is_momod2(member_id, chat_id) and not is_admin2(sender) then
   send_large_msg(receiver, "لآ يمكنـــــك🖐🏽 حظـٰر الادمـــن آؤ المديــــــر♥️❗️")
   return
        end
        send_large_msg(receiver, 'العضــــــــضو🗣 @'..member..' \nتہمہ بالفعــُُــل ✔️ حظره مہن المجموِعـــةة🍾🍷')
  ban_user(member_id, chat_id)
      elseif get_cmd == 'الغاء حظر' then
        send_large_msg(receiver, 'العضـــــو🗣 @'..member..' \nتہمہ الغــٰاء 🖐🏽حظــره مہنہ المجموعـُ ــةة🍾🍷')
        local hash =  'banned:'..chat_id
        redis:srem(hash, member_id)
        return 'العضـــٰو🗣 ['..user_id..'] \n\nتہمہ بالفعــُُــل ✔️ حظره مہنہ المجموِعـــةة🍾🍷'
      elseif get_cmd == 'حظر عام' then
        send_large_msg(receiver, 'العضـــــو🗣 [@'..member..'] \nتہمہ بالفعــــل ✔️ حظـــره مہنہ كہل المجموعــــــات♥️❗️ ')
  banall_user(member_id)
      elseif get_cmd == 'الغاء العام' then
        send_large_msg(receiver, 'العضــــٰو🗣 [@'..member..'] \nتہمہ بالفعـــٰل الغــٰٰـاء ✖️  حظُـره مہنہ كہل 🗣المجموعـــــات♥️❗️')
     unbanall_user(member_id)
    end
end

local function run(msg, matches)
local support_id = msg.from.id
 if matches[1]:lower() == 'ايدي' and msg.to.type == "chat" or msg.to.type == "user" then
    if msg.to.type == "user" then
      return "🔹  ايــــدي البوت : "..msg.to.id.. "\n\n🔹  ايــٰـدي حسابـــٰك : "..msg.from.id.. "\n\n🔹   المطــور :  @llX8Xll "
    end
    if type(msg.reply_id) ~= "nil" then
      local print_name = user_print_name(msg.from):gsub("‮", "")
   local name = print_name:gsub("_", "")
        savelog(msg.to.id, name.." ["..msg.from.id.."] used /id ")
        id = get_message(msg.reply_id,get_message_callback_id, false)
    elseif matches[1]:lower() == 'ايدي' then
      local name = user_print_name(msg.from)
      savelog(msg.to.id, name.." ["..msg.from.id.."] used /id ")
      return "ايـــــدي المجموعـــــةة🍾🍷" ..string.gsub(msg.to.print_name, "_", " ").. ":\n\n"..msg.to.id
    end
  end
  if matches[1]:lower() == 'مغادره' and msg.to.type == "chat" then-- /kickme
  local receiver = get_receiver(msg)
    if msg.to.type == 'chat' then
      local print_name = user_print_name(msg.from):gsub("‮", "")
   local name = print_name:gsub("_", "")
      savelog(msg.to.id, name.." ["..msg.from.id.."] left using kickme ")-- Save to logs
      chat_del_user("chat#id"..msg.to.id, "user#id"..msg.from.id, ok_cb, false)
    end
  end

  if not is_momod(msg) then -- Ignore normal users
    return
  end

  if matches[1]:lower() == "المحظورين" then -- Ban list !
    local chat_id = msg.to.id
    if matches[2] and is_admin1(msg) then
      chat_id = matches[2]
    end
    return ban_list(chat_id)
  end
  if matches[1]:lower() == 'حظر' then-- /ban
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      if is_admin1(msg) then
  msgr = get_message(msg.reply_id,ban_by_reply_admins, false)
      else
        msgr = get_message(msg.reply_id,ban_by_reply, false)
      end
      local user_id = matches[2]
      local chat_id = msg.to.id
    elseif string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
          return
        end
        if not is_admin1(msg) and is_momod2(matches[2], msg.to.id) then
           return "لآ يمكنـــــك🖐🏽 حظـٰر الادمـــن آؤ المديــــــر♥️❗️"
        end
        if tonumber(matches[2]) == tonumber(msg.from.id) then
           return "لآ يمكنـــــك 🗣حظــر نفســـك♥️❗️"
        end
        local print_name = user_print_name(msg.from):gsub("‮", "")
     local name = print_name:gsub("_", "")
  local receiver = get_receiver(msg)
        savelog(msg.to.id, name.."العضـــــو🗣 ["..msg.from.id.."] \nتہمہ بالفعــُُــل ✔️ حظــره مہن المجموِعـــةة🍾🍷".. matches[2])
        ban_user(matches[2], msg.to.id)
  send_large_msg(receiver, 'العضـــــو🗣 ['..matches[2]..'] \nتہمہ بالفعــُُــل ✔️ حظــره مہن المجموِعـــةة🍾🍷')
      else
  local cbres_extra = {
  chat_id = msg.to.id,
  get_cmd = 'حظر',
  from_id = msg.from.id,
  chat_type = msg.to.type
  }
  local username = string.gsub(matches[2], '@', '')
  resolve_username(username, kick_ban_res, cbres_extra)
    end
  end


  if matches[1]:lower() == 'الغاء حظر' then -- /unban
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      local msgr = get_message(msg.reply_id,unban_by_reply, false)
    end
      local user_id = matches[2]
      local chat_id = msg.to.id
      local targetuser = matches[2]
      if string.match(targetuser, '^%d+$') then
         local user_id = targetuser
         local hash =  'banned:'..chat_id
         redis:srem(hash, user_id)
         local print_name = user_print_name(msg.from):gsub("‮", "")
   local name = print_name:gsub("_", "")
         savelog(msg.to.id, name.."العضـــــو🗣 ["..msg.from.id.."] \nتہمہ الغــٰاء 🖐🏽حظــره مہنہ المجموعـُ ــةة🍾🍷".. matches[2])
         return 'العضـــــو🗣 '..user_id..'] \nتہمہ الغــٰاء 🖐🏽حظــره مہنہ المجموعـُ ــةة🍾🍷'
      else
  local cbres_extra = {
   chat_id = msg.to.id,
   get_cmd = 'الغاء حظر',
   from_id = msg.from.id,
   chat_type = msg.to.type
  }
  local username = string.gsub(matches[2], '@', '')
  resolve_username(username, kick_ban_res, cbres_extra)
 end
 end

if matches[1]:lower() == 'زحلكه' then
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      if is_admin1(msg) then
        msgr = get_message(msg.reply_id,Kick_by_reply_admins, false)
      else
        msgr = get_message(msg.reply_id,Kick_by_reply, false)
      end
 elseif string.match(matches[2], '^%d+$') then
  if tonumber(matches[2]) == tonumber(our_id) then
   return
  end
  if not is_admin1(msg) and is_momod2(matches[2], msg.to.id) then
   return "لآ يمكنـــــك🖐🏽 حظـٰر الادمـــن آؤ المديــــــر♥️❗️"
  end
  if tonumber(matches[2]) == tonumber(msg.from.id) then
   return "لآ يمكنـــــك 🗣حظــر نفســـك♥️❗️"
  end
    local user_id = matches[2]
    local chat_id = msg.to.id
    print("sexy")
  local print_name = user_print_name(msg.from):gsub("‮", "")
  local name = print_name:gsub("_", "")
  savelog(msg.to.id, name.." ["..msg.from.id.."] kicked user ".. matches[2])
  kick_user(user_id, chat_id)
 else
  local cbres_extra = {
   chat_id = msg.to.id,
   get_cmd = 'زحلكه',
   from_id = msg.from.id,
   chat_type = msg.to.type
  }
  local username = string.gsub(matches[2], '@', '')
  resolve_username(username, kick_ban_res, cbres_extra)
 end
end


 if not is_admin1(msg) and not is_support(support_id) then
  return
 end

  if matches[1]:lower() == 'حظر عام' and is_admin1(msg) then -- Global ban
    if type(msg.reply_id) ~="nil" and is_admin1(msg) then
      banall = get_message(msg.reply_id,banall_by_reply, false)
    end
    local user_id = matches[2]
    local chat_id = msg.to.id
      local targetuser = matches[2]
      if string.match(targetuser, '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
          return false
        end
         banall_user(targetuser)
         return 'العضـــــو🗣 ['..user_id..' ] \nتہمہ بالفعــــل ✔️ حظـــره مہنہ كہل المجموعــــــات♥️❗️'
     else
 local cbres_extra = {
  chat_id = msg.to.id,
  get_cmd = 'حظر عام',
  from_id = msg.from.id,
  chat_type = msg.to.type
 }
  local username = string.gsub(matches[2], '@', '')
  resolve_username(username, kick_ban_res, cbres_extra)
      end
  end
  if matches[1]:lower() == 'الغاء العام' then -- Global unban
    local user_id = matches[2]
    local chat_id = msg.to.id
      if string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
           return false
        end
         unbanall_user(user_id)
         return 'العضـــــو🗣 ['..user_id..' ] \nتہمہ بالفعـــٰل الغــٰٰـاء ✖️  حظُـره مہنہ كہل 🗣المجموعـــــات♥️❗️'
    else
  local cbres_extra = {
   chat_id = msg.to.id,
   get_cmd = 'الغاء العام',
   from_id = msg.from.id,
   chat_type = msg.to.type
  }
  local username = string.gsub(matches[2], '@', '')
  resolve_username(username, kick_ban_res, cbres_extra)
      end
  end
  if matches[1]:lower() == "قائمه العام" then -- Global ban list
    return banall_list()
  end
end

return {
  patterns = {
    "^(حظر عام) (.*)$",
    "^(حظر عام)$",
    "^(المحظورين) (.*)$",
    "^(المحظورين)$",
    "^(قائمه العام)$",
 "^(مغادره)",
    "^(زحلكه)$",
 "^(حظر)$",
    "^(حظر) (.*)$",
    "^(الغاء حظر) (.*)$",
    "^(الغاء العام) (.*)$",
    "^(الغاء الغام)$",
    "^(زحلكه) (.*)$",
    "^(الغاء حظر)$",
    "^(ايدي)$",
    "^[#!/](حظر عام) (.*)$",
    "^[#!/](حظر عام)$",
    "^[#!/](المحظورين) (.*)$",
    "^[#!/](المحظورين)$",
    "^[#!/](قائمه العام)$",
 "^[#!/](مغادره)",
    "^[#!/](دي)$",
 "^[#!/](حظر)$",
    "^[#!/](حظر) (.*)$",
    "^[#!/](الغاء حظر) (.*)$",
    "^[#!/](الغاء العام) (.*)$",
    "^[#!/](الغاء العام)$",
    "^[#!/](زحلكه) (.*)$",
    "^[#!/](الغاء حظر)$",
    "^[#!/](ايدي)$",
    "^!!tgservice (.+)$"
  },
  run = run,
  pre_process = pre_process
}



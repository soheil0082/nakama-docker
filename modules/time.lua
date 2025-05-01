local nk = require("nakama")

local function reward_inviter(context, data)
    local input = nk.json_decode(data)
  
    nk.storage_write({
      {
        collection = "users",
        key = input.userId,
        user_id = input.userId,
        value = nk.json_decode(input.data),
        permission_read = 2,
      }
    })
end

local function check_key(context, data)
    local input = nk.json_decode(data)
    local key = input.key
    local collection = input.collection
  
    local result = nk.storage_read({
      {
        collection = collection,
        key = key,
        user_id = "8e3e162c-2ee9-44da-bedc-d15834ef6e1a"
      }
    })
  
    if #result == 0 then
      return ""
    end
  
    return result[1].value.Uid
  end  

  local function write_object(context, data)
    local input = nk.json_decode(data)
    local key = input.key
    local collection = input.collection
    local object = input.object
    local id = input.id
  
    local ok, err = pcall(function()
      if id ~= nil and #id > 1 then
        nk.storage_write({
          {
            collection = collection,
            value = nk.json_decode(object),
            key = key,
            user_id = id
          }
        })
      else
        nk.storage_write({
          {
            collection = collection,
            value = nk.json_decode(object),
            key = key,
            user_id = "8e3e162c-2ee9-44da-bedc-d15834ef6e1a"
          }
        })
      end
        end)
        
        if not ok then
            error("Could not write to the server. Error code: " .. tostring(err))
        end
  end  

local function getservertime(context, payload)
    return os.date("%Y%m%d%H%M%S")
end

nk.register_rpc(getservertime, "GetServerTime")
nk.register_rpc(reward_inviter, "reward_inviter")
nk.register_rpc(check_key, "check_key")
nk.register_rpc(write_object, "write_object")


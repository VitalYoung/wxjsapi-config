require "wxjsapi/version"

class WechatConfig
  attr_accessor :debug, :appId, :appSecret, :timestamp, :nonceStr, :signature, :jsApiList
  def initialize appId, appSecret, jsApiList
    #全局缓存access_token
    $access_token = Hash.new
    $access_token['access_token'] = ''
    $access_token['expires_in'] = Time.new
    #全局缓存jsapi_ticket
    $jsapi_ticket = Hash.new
    $jsapi_ticket['jsapi_ticket'] = ''
    $jsapi_ticket['expires_in'] = Time.new

    @appId = appId
    @appSecret = appSecret
    if jsApiList.present?
      @jsApiList = jsApiList
    else
      @jsApiList = "onMenuShareTimeline,onMenuShareAppMessage,onMenuShareQQ,onMenuShareWeibo,startRecord,stopRecord,onVoiceRecordEnd,playVoice,pauseVoice,stopVoice,onVoicePlayEnd,uploadVoice,downloadVoice,chooseImage,previewImage,uploadImage,downloadImage,translateVoice,getNetworkType,openLocation,getLocation,hideOptionMenu,showOptionMenu,hideMenuItems,showMenuItems,hideAllNonBaseMenuItem,showAllNonBaseMenuItem,closeWindow,scanQRCode,chooseWXPay,openProductSpecificView,addCard,chooseCard,openCard"
    end
    self.debug = 'false'
  end

  def wxJsSDKSign url
    uuid = UUID.new
    self.timestamp = Time.new.to_i.to_s
    self.nonceStr = uuid.generate
    ticket = self.wxGetJsAPITicket
    puts 'ticket:' + ticket.to_s
    if ticket.blank?
      return false
    end

    str = 'jsapi_ticket=' + ticket.to_s + '&noncestr=' + self.nonceStr.to_s + '&timestamp=' + self.timestamp + '&url=' + url.to_s
    puts str
    self.signature = Digest::SHA1.hexdigest(str)
  end

  #获取调用微信JS接口的临时票据 jsapi_ticket
  def wxGetJsAPITicket
    today = Time.new
    ticket_ex = $jsapi_ticket['expires_in']
    if today < ticket_ex
      $jsapi_ticket['jsapi_ticket']
    else
      token_ex = $access_token['expires_in']
      if today > token_ex
        token = self.wxGetAccessToken
        if token.blank?
          return nil
        end
      else
        token = $access_token['access_token']
      end
      puts 'token:' + token.to_s
      url = 'https://api.weixin.qq.com/cgi-bin/ticket/getticket?type=jsapi&' + 'access_token=' + token.to_s
      response = RestClient.get url
      if response.code == 200
        result = ActiveSupport::JSON.decode(response)
        puts 'ticket result:' + result.to_s
        ticket = result['ticket']
        $jsapi_ticket['jsapi_ticket'] = ticket
        $jsapi_ticket['expires_in'] = Time.new + result['expires_in'].to_i
        return ticket
      else
        return nil
      end
    end
  end

  #获取公众号的全局唯一票据access_token
  def wxGetAccessToken
    today = Time.new
    token_ex = $access_token['expires_in']
    puts today<token_ex
    if today < token_ex
      $access_token['access_token']
    else
      url = 'https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid='+ self.appId.to_s + '&secret=' + self.appSecret.to_s
      puts 'url:' + url.to_s
      response = RestClient.get url
      if response.code == 200
        result = ActiveSupport::JSON.decode(response)
        puts 'token result:' + result.to_s
        token = result['access_token']
        $access_token['access_token'] = token
        $access_token['expires_in'] = Time.new + result['expires_in'].to_i
        return token
      else
        return nil
      end
    end
  end
end

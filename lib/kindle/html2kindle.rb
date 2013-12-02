require 'open-uri'
require 'tmpdir'
#
# uriからhtmlファイルを取得してkindle-personal-documentサービス用の
# メールアドレスに送りつけるModule
# 使用方法
# Html2Kindle.send('test@kindle.com','http://law.e-gov.go.jp/htmldata/S28/S28HO006.html')
# Html2Kindle.send('test@kindle.com',['http://.../test1.html','http://.../test2.html'])
#

module Html2Kindle
  def self.send(mail_adress , uri)
    #uriはStringもしくはArrayを想定
    uri = Array[uri] unless uri .instance_of?(Array)

    #まずは1fileに対応
    file_name =File.basename(uri[0])
    #TODO Dir#tmpdir は Dir#mktmpdirに切り替える予定
    path = "#{Dir.tmpdir}/#{file_name}"
    self.get_html(path ,uri[0])
  end

  private 
  
  def self.get_html(file_path , uri)
    open(uri) do |_uri|
      File.open(file_path, "wb") do |html|
        html.puts(_uri.read)
      end
    end
  end
  def self.send_mail(adress,file)
    #TODO mail処理をかく
  end
end

Html2Kindle.send('test@kindle.com','http://law.e-gov.go.jp/htmldata/S28/S28HO006.html')

require 'open-uri'
require 'tmpdir'
#
# uriからファイルを取得してkindle-personal-documentサービス用の
# メールアドレスに送りつけるModule
# 使用方法
# Kindle::Mail2MyKindle.send('test@kindle.com','http://law.e-gov.go.jp/htmldata/S28/S28HO006.html')
#
module Kindle
  class Mail2MyKindle
    def self.send(mail_adress , uri)
      #uriはStringもしくはArrayを想定
      # uri = Array[uri] unless uri .instance_of?(Array)

      #まずは1fileに対応
      file_name =File.basename(uri)
      
      #TODO 対応している拡張子かチェックを書く
      
      #TODO Dir#tmpdir は Dir#mktmpdirに切り替える予定
      path = "#{Dir.tmpdir}/#{file_name}"
      self.get_file(path ,uri)
    end

    private 
    
    def self.get_file(file_path , uri)
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
end


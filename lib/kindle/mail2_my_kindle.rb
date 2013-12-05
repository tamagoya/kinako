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

      Dir.mktmpdir{|dir|
        #まずは1fileに対応
        file_name =File.basename(uri)
        #TODO 対応している拡張子かチェックを書く
        file_path = "#{dir}/#{file_name}"
        self.get_file(file_path , uri)
        Mailer.send_mail(mail_adress , file_path).deliver
      }

    end

    def self.get_file(file_path , uri)
      open(uri) do |_uri|
        File.open(file_path, "wb") do |html|
          html.puts(_uri.read)
        end
      end
    end
  end

  class Mailer < ActionMailer::Base
    #TODO FROM側のメールアドレスは設定で指定するようにしたい
    default :from => 'kinoko@gmail.com'

    def send_mail(mail_adress , file_path) 
      #ファイル添付
      attachments[File.basename(file_path)] = {
        :content => File.read(file_path , :mode => 'rb'),
        :transfer_encoding => :binary
      }

      mail(:to => mail_adress,
           :subject => '',
           :body =>'')
    end
  end
end


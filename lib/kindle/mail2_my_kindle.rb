require 'open-uri'
require 'tmpdir'
#
# uriからファイルを取得してkindle-personal-documentサービス用の
# メールアドレスに送りつけるModule
# 使用方法
# Kindle::Mail2MyKindle.send('test@kindle.com','http://law.e-gov.go.jp/htmldata/S28/S28HO006.html')
#
module Kindle
  FILENAME_EXTENSION = ['doc','docx','html','htm','rtf','jpeg','jpg','mobi','azw','gif','png','bmp','pdf']

  class Mail2MyKindle
    def self.send(mail_adress , uri)
      #uriはStringもしくはArrayを想定
      # uri = Array[uri] unless uri .instance_of?(Array)

      file_name =save_file_name(uri)
      #対応していない拡張子の場合は終了
      #TODO NameErrorあたりを投げるのが妥当か考える
      return if file_name == nil

      Dir.mktmpdir{|dir|
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

    #URLから保存するファイルを名を返す
    #拡張子のチェックを行いkindleが対応していない場合は nil
    def self.save_file_name(uri)
      #param cut
      file_name =File.basename(uri).gsub(/\?.*$/,'')

      ext = File.extname(file_name).downcase
      return file_name + '.html' if "".eql?(ext)
      FILENAME_EXTENSION.include?(ext.gsub(/\./,''))  ? file_name
                                                      : nil
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


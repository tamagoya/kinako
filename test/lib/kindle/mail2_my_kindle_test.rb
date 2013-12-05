require 'test_helper'

class Mail2MyKindleTest < ActiveSupport::TestCase

  test "fileパスとURLを渡したらファイルをダウンロードして保存すること" do
    #ファイル削除
    File.unlink("#{Dir.tmpdir}/test.html") if Dir::entries(Dir.tmpdir).include?('test.html')
    
    Kindle::Mail2MyKindle.get_file("#{Dir.tmpdir}/test.html",'http://qwik.jp/minamirb/FrontPage.html')

    #ファイルが存在を確認
    assert Dir::entries(Dir.tmpdir).include?('test.html')

    #ファイル削除
    File.unlink("#{Dir.tmpdir}/test.html") if Dir::entries(Dir.tmpdir).include?('test.html')
  end

  test "メールの送信テスト" do
    #グローバルな変数みたいなので毎回クリア?
    ActionMailer::Base.deliveries.clear

    #テスト用ファイル作成
    File.open("#{Dir.tmpdir}/test.html", "w").close()

    #メール送信
    email = Kindle::Mailer.send_mail("test@gmail.com" , "#{Dir.tmpdir}/test.html").deliver

    #メールがキューに入れられたか？
    assert !ActionMailer::Base.deliveries.empty?

    # メール内容テスト
    assert_equal email.from , ["kinoko@gmail.com"]
    assert_equal email.to , ["test@gmail.com"]
    #TODO 添付ファイルのファイル名のテストを行いたいがうまくできない

    #グローバルな変数みたいなので毎回クリア?
    ActionMailer::Base.deliveries.clear
  end

  test "メールアドレスとURLを渡したらURLを取得してメール送信を行うこと" do
    ActionMailer::Base.deliveries.clear

    Kindle::Mail2MyKindle.send("test@gmial.com",'http://qwik.jp/minamirb/FrontPage.html')

    # メール内容テスト
    assert_equal email.from , ["kinoko@gmail.com"]
    assert_equal email.to , ["test@gmail.com"]
    #TODO 添付ファイルのファイル名のテストを行いたいがうまくできない

    ActionMailer::Base.deliveries.clear
  end
end 

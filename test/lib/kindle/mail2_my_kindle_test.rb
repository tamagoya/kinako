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

  test "ファイルの拡張子をチェックしてファイル名を取得できること" do
    assert_equal Kindle::Mail2MyKindle.save_file_name('http://qwik.jp/minamirb/FrontPage.html') , 'FrontPage.html'
    assert_equal Kindle::Mail2MyKindle.save_file_name('http://qwik.jp/minamirb/FrontPage.pdf') , 'FrontPage.pdf'

    #対応していない拡張子の場合はnil
    assert_nil Kindle::Mail2MyKindle.save_file_name('http://qwik.jp/minamirb/FrontPage.test')

    #拡張子が無い場合はhtmlとみなす
    assert_equal Kindle::Mail2MyKindle.save_file_name('http://qwik.jp/minamirb/FrontPage') , 'FrontPage.html'

    #パラメータは除いて判定する
    assert_equal Kindle::Mail2MyKindle.save_file_name('http://www.amazon.co.jp/gp/help/customer/display.html?nodeId=xxxxxxxxx') , 'display.html'
    assert_nil Kindle::Mail2MyKindle.save_file_name('http://www.amazon.co.jp/gp/help/customer/display.test?nodeId=xxxxxxxxx')

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

  test "メールアドレスとURLを渡したらURLからファイルを取得してメール送信を行うこと" do
    ActionMailer::Base.deliveries.clear

    Kindle::Mail2MyKindle.send("test@gmail.com",'http://qwik.jp/minamirb/FrontPage.html')
    # メール内容テスト
    assert_equal ActionMailer::Base.deliveries.last.from , ["kinoko@gmail.com"]
    assert_equal ActionMailer::Base.deliveries.last.to , ["test@gmail.com"]
    #TODO 添付ファイルのファイル名のテストを行いたいがうまくできない

    ActionMailer::Base.deliveries.clear
  end

  test "対応していないファイルフォーマットの場合はNameErrorが投げられること" do
    ActionMailer::Base.deliveries.clear
    assert_raise(NameError) {
      Kindle::Mail2MyKindle.send("test@gmial.com",'http://qwik.jp/minamirb/FrontPage.test')
    }
  end
end 

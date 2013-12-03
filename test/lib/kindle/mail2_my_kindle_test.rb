require 'test_helper'

class Mail2MyKindleTest < ActiveSupport::TestCase
  test "urlを渡したら添付ファイルを作成すること" do 
    #テストファイルを削除
    
    File.unlink("#{Dir.tmpdir}/S28HO006.html") if Dir::entries(Dir.tmpdir).include?('S28HO006.html')

    Kindle::Mail2MyKindle.send('test@kindle.com','http://law.e-gov.go.jp/htmldata/S28/S28HO006.html')
    #ファイルが存在を確認
    assert Dir::entries(Dir.tmpdir).include?('S28HO006.html')
  end
end 

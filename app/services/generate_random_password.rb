class GenerateRandomPassword
  # http://keepass.info/help/base/pwgenerator.html
  def self.call
    KeePass::Password.generate('luAAAAAA')
  end
end

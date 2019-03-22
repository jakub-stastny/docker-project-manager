# This is currently not being used, because I cannot figure out how to convert the public key into OpenSSH-compatible format.
# https://github.com/botanicus/docker-project-manager/issues/26
#
# Another thing is the comment bit. It might be just a matter of adding it as text at the end of the public key, but it might be more tricky than that.
require "openssl_ext"

class SSHKeyPair
  def save(ssh_dir_path) : Nil
    File.open(File.join(ssh_dir_path, "id_rsa"), "w", 0o644) do |file|
      file.puts(self.private_key.to_pem)
    end

    File.open(File.join(ssh_dir_path, "id_rsa.pub"), "w", 0o600) do |file|
      file.puts(self.public_key.to_pem)
    end
  end

  def private_key
    @private_key ||= OpenSSL::RSA.new(2048)
  end

  def public_key
    self.private_key.public_key
  end
end

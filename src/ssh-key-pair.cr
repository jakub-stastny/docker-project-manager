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

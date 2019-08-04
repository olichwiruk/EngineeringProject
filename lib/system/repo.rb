module System
  class Repo
    def all_users
      %x[cut -d: -f1 /etc/passwd].split(' ')
    end
  end
end

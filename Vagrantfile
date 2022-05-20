Vagrant.configure("2") do |config|
    # app server
    config.vm.define "leo-dseng" do |dseng|
      dseng.vm.box = "ubuntu/bionic64" # ubuntu/bionic64
      dseng.vm.network "forwarded_port", guest: 3000, host: 3000 # forward port 3000 to host 3000
      dseng.vm.network "private_network", ip: "192.168.56.101" # allow other computers to connect via this ip in local network
      #dseng.vm.synced_folder "", "/PHPCourseManagement" # sync folder with host
      dseng.vm.provision :shell, :path => "./app.sh" # run script on boot
      dseng.vm.provision "file", source: "sqlconfig.sql", destination: "sqlconfig.sql" # run configuration script
      dseng.vm.provision "file", source: "dunwoody_advising_schema.sql", destination: "dunwoody_advising_schema.sql" # run schema setup
      dseng.vm.provision "file", source: "SENG_Fall_2022_course_data.sql", destination: "SENG_Fall_2022_course_data.sql" # add premade courses
      dseng.vm.provision :shell, inline: <<-SHELL
      apt-get update
      mysql -t < sqlconfig.sql
      mysql -t < dunwoody_advising_schema.sql
      mysql -t < SENG_Fall_2022_course_data.sql
      SHELL
    end
  end
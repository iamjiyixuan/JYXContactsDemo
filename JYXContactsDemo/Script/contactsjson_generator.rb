path = "../Resource/Images";

File.open("../Resource/Jsons/contacts.json", "w:UTF-8") do |f|
        
    f.puts "{ \"contacts\": ["
    
    $i = 0;
    
    Dir.foreach(path) {
        |file|
        if file.include?(".jpg")
            
            filename = file.split(".jpg").first;
            name = filename.split("】")[1];
            
            if $i > 0 then f.puts "," end
            
            f.puts "{ \"name\": \"" + name + "\", \"avatarImageName\" : \"" + file + "\", \"kingdom\" : \"" + filename[1, 1] + "\" }"
            
            $i += 1;
        end
        
        
    }
    
    f.puts "] }"
    
end


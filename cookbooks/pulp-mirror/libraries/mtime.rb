def file_age(name)
  (Time.now - File.mtime(name))/(24*3600)
end

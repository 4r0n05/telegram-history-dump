require 'pathname'
require_relative './dump_prepender'

def get_safe_name(name)
  bad_characters = /([\/\\<>:"|?*]|[^\u0021-\uFFFF])/
  clean_name = name.gsub(bad_characters, $config['character_substitute'])
  truncate_to_bytesize(clean_name, 220, '_[truncated]')
end

def get_full_name(user)
  return '' if !user || user['first_name'].to_s == ''
  name = user['first_name']
  if $config['display_last_name'] && user['last_name'].to_s != ''
    name += ' %s' % user['last_name']
  end
  name
end

def get_backup_dir
  File.expand_path(File.join('..', '..', $config['backup_dir']), __FILE__)
end

def get_media_dir(dialog)
  File.join(get_backup_dir, 'media', get_safe_name(dialog['print_name']))
end

def strip_tg_special_chars(print_name)
  print_name.gsub(/[_@# ]/, '')
end

def relativize_output_path(path)
  Pathname(path).relative_path_from(Pathname(get_backup_dir)).to_s
end

def truncate_to_bytesize(str, size, ellipsis = '')
  str.each_char.each_with_object('') do |char,result|
    if result.bytesize + char.bytesize > (size - ellipsis.bytesize)
      break result + ellipsis
    else
      result << char
    end
  end
end

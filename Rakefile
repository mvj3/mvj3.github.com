require 'date'

desc 'create a new draft post (TITLE required)'
task :post do
  raise "TITLE required" unless ENV['TITLE']
  title = ENV['TITLE']
  slug = "#{Date.today}-#{title.downcase.gsub(/[^\w]+/, '-')}"

  file = File.join File.dirname(__FILE__), '_posts', slug + '.markdown'

  File.open file, "w"  do |f|
    f << <<-EOS.gsub(/^    /, '')
    ---
    layout: post
    title: #{title} | 世界的审美！
    short_title: #{title}
    published: false
    date: #{Time.now.strftime("%Y-%m-%d %T")} +00:00
    categories: []
    ---

    EOS
  end

  system "#{ENV['EDITOR']} #{file}"
end

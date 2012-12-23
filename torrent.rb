# Creates a torrent file with your generated site. You should serve the files
# with your cliente.
#
# Default config values
# torrent:
#   announce: 'udp://tracker.publicbt.com:80'
#   file:     'site.torrent'
#   flags:    '--verbose'
#   bin:      'mktorrent'
#
module Jekyll
  class Site

    def process_with_torrent
      # Original Site.process method
      process_without_torrent
      self.make_torrent
    end

    def make_torrent
      # The torrent file is written at the root of the site
      file = "#{dest}/#{torrent['file']}"

      # Delete existing files since `mktorrent` doesn't overwrite it
      File.delete(file) if File.exists?(file)

      puts "Generating torrent file at #{file}"
      puts `#{torrent['bin']} -a #{torrent['announce']} -o #{file} #{torrent['flags']} #{dest}`
    end

    # Alias method chain
    alias_method :process_without_torrent, :process
    alias_method :process, :process_with_torrent

    private
      # Merges config with default values
      def torrent
        @torrent_config ||= { 
          'announce'  => 'udp://tracker.publicbt.com:80',
          'file'      => 'site.torrent',
          'flags'     => '--verbose',
          'bin'       => 'mktorrent'
        }.merge(config['torrent'] || {})
      end
  end
end

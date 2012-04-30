module Import
  class << self

    def faces(file)
      File.open(file, "r") do |infile|
        while (line = infile.gets)
          first_name, last_name, username, password = line.split('|')
          face = Face.enroll(
            :first_name => first_name,
            :last_name => last_name,
            :username => username,
            :password => password
          )
        end
      end
    end

    def connections(file)
      # ABuyanskyy1 InMyFace AMonahan1
      File.open(file, "r") do |infile|
        while (line = infile.gets)
          face_username, in_or_out, other_face_username = line.split(' ')
          face = Face.find(face_username)
          other_face = Face.find(other_face_username)
          case in_or_out
          when "InMyFace"
            face.in_my(other_face)
          when "OuttaMyFace"
            face.outta_my(other_face)
          end
        end
      end
    end

    def posts(file)
      File.open(file, "r") do |infile|
        while (line = infile.gets)
          face_username, body = line.split(' posts ')
          Face.find(face_username).post(body)
        end
      end
    end
  end
end

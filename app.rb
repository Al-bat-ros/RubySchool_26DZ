require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


configure do
  

# db = get_db
  
# db.execute 'CREATE TABLE IF NOT EXISTS `Visit` 
#           ( 
               
#              `Id` INTEGER PRIMARY KEY AUTOINCREMENT,
#              `Hairdresser` TEXT, `Name` TEXT,
#              `NumberPhone` INTEGER, `DataStamp` INTEGER 

#           )'

end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end


get '/' do
   erb 'Can you handle a <a href="/secure/place">secret</a>?'
end



post '/visit' do
  @list = params[:list]
  @username = params[:user_name]
  @namber_phone = params[:namber_phone]
  @data_time = params[:data_time]
  @color = params[:color]

  hh = {:user_name => 'Введите имя',
        :namber_phone => 'Введите номер телефона',
        :data_time => 'Введите дату и время'}
   #  Вариант первый
   # hh.each do|key,value|
        # if params[key] == ''

          # @error = hh[key]

          # return erb :visit

        # end

    # end 

    # Вариант второй

    @error = hh.select {|key,_| params[key] == ""}.values.join(',')

     #Добавление в БД !!! ТАК НЕНАДО ДЕЛАТЬ !!!

     #@db_visit.execute "INSERT INTO Visit (Hairdresser,Name,NumberPhone,DataStamp) VALUES ('#{@list}', '#{@username}', '#{@namber_phone}', '#{@data_time}')"
     

     #Добавление в БД !!! НУЖНО ДЕЛАТЬ ТАК !!!


     db = get_db
     db.execute 'INSERT INTO Visit 
              (Hairdresser,Name,NumberPhone,DataStamp) VALUES (?,?,?,?)', [@list,@username,@namber_phone,@data_time]
   


  f = File.open './public/user.txt','a'
  f.write "User:#{@username}, Phone:#{@namber_phone}, Data:#{@data_time}, Hairdresser:#{@list}, Color: #{@color}. "
  f.close

  

  erb :visit
  
end



post '/contacts' do
  @Email1 = params[:Email1]
  @Message = params[:Message]

  hhh = {:Email1 => 'Напишите email',
         :Message => 'Напишите сообщение'}

     @error = hhh.select{|key,_| params[key] == ""}.values.join(',')   


     f = File.open './public/contacts.txt','a'
     f.write "Contacts: #{@Email1}, Message: #{@Message}. "
     f.close

     erb 'Мы сохранили ваш контакт и сообщение!!! <a href="/contacts">Contacts</a>?'
     
end


get '/about' do
  @error = 'Иди делай уроки!!!'
  erb :about
end

get '/visit' do
  erb :visit  
end

get '/contacts' do
  erb :contacts
end

get '/login/form' do
  erb :login_form
end

post '/login/form' do
  @Email2 = params[:Email2]
  @Password2 = params[:Password2]

  if @Email2 == 'admin@mail.ru' && @Password2 == '123456'

        erb :admin

    else
          erb 'Проверьте логин и пароль'
  end

end

get '/admin' do

  db = get_db

  @results = db.execute 'select * from Visit order by id desc'
   
  erb :admin

end

def get_db

    db = SQLite3::Database.new 'db visit'
    db.results_as_hash = true
    return db
end

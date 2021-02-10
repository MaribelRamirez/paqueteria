require 'json'
class PrincipalController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @result=Envio.all
  end

  def buscar_json
=begin
método para leer un archivo Json, guargar la informacion en
base de datos y al mismo tiempo en un hash para poder ser mostrado en una vista
=end
    file = params[:file]
    @result = []

    if String(File.extname(file.original_filename)).in?(%w(.json))
      f=conectar()
      json = File.read(file.path)
      obj = JSON.parse(json,symbolize_names: true)

      obj.each do |cadena|
        begin
          x=f.track(:tracking_number => cadena[:tracking_number]).first
          @result << {:tracking_number => cadena[:tracking_number],:status=>x.status,:nombre=>cadena[:carrier],:description=>x.events.first.description}
        rescue Exception=>error
          @result << {:tracking_number => cadena[:tracking_number], :status=>error, :nombre=> cadena[:carrier], :description=>error}
        end
      end
      guardar(@result)
    end
    render :mostrar
  end

  def buscar
=begin
método para realizar la busqueda de un solo numero de guia, guargar la informacion en
base de datos y al mismo tiempo en un hash para poder ser mostrado en una vista
=end
    @result = []
    f=conectar
    begin
      x=f.track(:tracking_number => params[:numero]).first
      @result << {:tracking_number => params[:numero],:status=>x.status,:nombre=>'FEDEX',:description=>x.events.first.description}
    rescue Exception=>error
      @result << {:tracking_number => params[:numero], :status=>error, :nombre=> "FEDEX", :description=>error}
    end

    guardar(@result)
    render :mostrar
  end

  def conectar
=begin
método para conectar con la API de fedex
=end
    Fedex::Shipment.new(:key => 'VZ0tu2xxC4LKxZY6',
                        :password => 'AKOh8wjdYsJtNI6CFKaxPFLka',
                        :account_number => '802388543',
                        :meter => '100495015',
                        :mode => 'test')
  end

  def guardar result
=begin
método para guargar la informacion
en base de datos
=end
    result.each do |res|
      @envio=Envio.find_by_guide_number(res[:tracking_number])
      if @envio.blank?
        Envio.create(guide_number: res[:tracking_number],description: res[:description],name: res[:nombre],status: res[:status] )
      else
        @envio.update(guide_number: res[:tracking_number],description: res[:description],name: res[:nombre],status: res[:status] )
      end
    end
  end
end

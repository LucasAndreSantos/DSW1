# Use a imagem do OpenJDK como base
FROM openjdk:11-jdk

# Defina o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copie o arquivo JAR gerado pelo Maven para o diretório de trabalho
COPY target/AloMundoMVC-0.0.1-SNAPSHOT.jar /app/

# Exponha a porta que a aplicação estará ouvindo (deve corresponder à porta definida na aplicação Spring Boot)
EXPOSE 8080

# Comando para iniciar a aplicação quando o contêiner for iniciado
CMD ["java", "-jar", "AloMundoMVC-0.0.1-SNAPSHOT.jar"]

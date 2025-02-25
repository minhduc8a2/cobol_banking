FROM openjdk:22-jdk
ADD target/bank.jar bank.jar
ENTRYPOINT ["java","-jar","bank.jar"]
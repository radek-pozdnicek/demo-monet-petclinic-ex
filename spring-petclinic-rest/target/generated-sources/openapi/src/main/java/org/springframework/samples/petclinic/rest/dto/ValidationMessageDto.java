package org.springframework.samples.petclinic.rest.dto;

import java.net.URI;
import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonTypeName;
import java.util.HashMap;
import java.util.Map;
import java.time.OffsetDateTime;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import org.hibernate.validator.constraints.*;
import io.swagger.v3.oas.annotations.media.Schema;


import java.util.*;
import jakarta.annotation.Generated;

/**
 * Messages describing a validation error.
 */

@Schema(name = "ValidationMessage", description = "Messages describing a validation error.")
@JsonTypeName("ValidationMessage")
@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", date = "2023-06-19T19:07:50.496623100+01:00[GMT+01:00]")
public class ValidationMessageDto extends HashMap<String, Object> {

  @JsonProperty("message")
  private String message;

  public ValidationMessageDto message(String message) {
    this.message = message;
    return this;
  }

  /**
   * The valiation message.
   * @return message
  */
  
  @Schema(name = "message", accessMode = Schema.AccessMode.READ_ONLY, example = "[Path '/lastName'] Instance type (null) does not match any allowed primitive type (allowed: [\"string\"])", description = "The valiation message.", requiredMode = Schema.RequiredMode.REQUIRED)
  public String getMessage() {
    return message;
  }

  public void setMessage(String message) {
    this.message = message;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    ValidationMessageDto validationMessage = (ValidationMessageDto) o;
    return Objects.equals(this.message, validationMessage.message) &&
        super.equals(o);
  }

  @Override
  public int hashCode() {
    return Objects.hash(message, super.hashCode());
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class ValidationMessageDto {\n");
    sb.append("    ").append(toIndentedString(super.toString())).append("\n");
    sb.append("    message: ").append(toIndentedString(message)).append("\n");
    sb.append("}");
    return sb.toString();
  }

  /**
   * Convert the given object to string with each line indented by 4 spaces
   * (except the first line).
   */
  private String toIndentedString(Object o) {
    if (o == null) {
      return "null";
    }
    return o.toString().replace("\n", "\n    ");
  }
}


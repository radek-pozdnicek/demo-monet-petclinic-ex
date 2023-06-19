package org.springframework.samples.petclinic.rest.dto;

import java.net.URI;
import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonTypeName;
import java.time.OffsetDateTime;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import org.hibernate.validator.constraints.*;
import io.swagger.v3.oas.annotations.media.Schema;


import java.util.*;
import jakarta.annotation.Generated;

/**
 * VisitAllOfDto
 */

@JsonTypeName("Visit_allOf")
@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", date = "2023-06-19T19:07:50.496623100+01:00[GMT+01:00]")
public class VisitAllOfDto {

  @JsonProperty("id")
  private Integer id;

  @JsonProperty("petId")
  private Integer petId;

  public VisitAllOfDto id(Integer id) {
    this.id = id;
    return this;
  }

  /**
   * The ID of the visit.
   * minimum: 0
   * @return id
  */
  @Min(0) 
  @Schema(name = "id", accessMode = Schema.AccessMode.READ_ONLY, example = "1", description = "The ID of the visit.", requiredMode = Schema.RequiredMode.REQUIRED)
  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public VisitAllOfDto petId(Integer petId) {
    this.petId = petId;
    return this;
  }

  /**
   * The ID of the pet.
   * minimum: 0
   * @return petId
  */
  @Min(0) 
  @Schema(name = "petId", accessMode = Schema.AccessMode.READ_ONLY, example = "1", description = "The ID of the pet.", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
  public Integer getPetId() {
    return petId;
  }

  public void setPetId(Integer petId) {
    this.petId = petId;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    VisitAllOfDto visitAllOf = (VisitAllOfDto) o;
    return Objects.equals(this.id, visitAllOf.id) &&
        Objects.equals(this.petId, visitAllOf.petId);
  }

  @Override
  public int hashCode() {
    return Objects.hash(id, petId);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class VisitAllOfDto {\n");
    sb.append("    id: ").append(toIndentedString(id)).append("\n");
    sb.append("    petId: ").append(toIndentedString(petId)).append("\n");
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


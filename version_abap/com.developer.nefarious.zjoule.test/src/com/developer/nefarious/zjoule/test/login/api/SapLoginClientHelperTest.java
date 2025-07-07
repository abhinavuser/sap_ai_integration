package com.developer.nefarious.zjoule.test.login.api;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;

import java.net.URI;
import java.util.concurrent.ThreadLocalRandom;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.MockedStatic;

import com.developer.nefarious.zjoule.plugin.login.api.GetDeploymentsResponse;
import com.developer.nefarious.zjoule.plugin.login.api.GetResourceGroupsResponse;
import com.developer.nefarious.zjoule.plugin.login.api.SapLoginClientHelper;
import com.google.gson.Gson;

public class SapLoginClientHelperTest {

	private SapLoginClientHelper cut;

	private String randomWord() {
		final String[] WORDS = { "apple", "banana", "grape" };
		int randomIndex = ThreadLocalRandom.current().nextInt(WORDS.length);
		return WORDS[randomIndex];
	}

	@BeforeEach
	public void setUp() {
		cut = new SapLoginClientHelper();
	}

	@Test
	public void shouldConvertTheDeploymentsResponseBodyToObject() {
		// Arrange
		Gson gson = new Gson();
		String mockResponseBody = "{ \"count\": 1 }";
		GetDeploymentsResponse expectedObject = gson.fromJson(mockResponseBody, GetDeploymentsResponse.class);
		// Act
		GetDeploymentsResponse returnObject = cut.parseDeploymentsResponseToObject(mockResponseBody);
		// Assert
		assertEquals(returnObject.getCount(), expectedObject.getCount());
	}

	@Test
	public void shouldConvertTheResourceGroupsResponseBodyToObject() {
		// Arrange
		Gson gson = new Gson();
		String mockResponseBody = "{ \"count\": 1 }";
		GetResourceGroupsResponse expectedObject = gson.fromJson(mockResponseBody, GetResourceGroupsResponse.class);
		// Act
		GetResourceGroupsResponse returnObject = cut.parseResourceGroupsResponseToObject(mockResponseBody);
		// Assert
		assertEquals(returnObject.getCount(), expectedObject.getCount());
	}

	@Test
	public void shouldCreateTheAuthUri() {
		// Arrange
		URI expectedObject = mock(URI.class);
		String mockTokenEndpoint = randomWord();
		try (MockedStatic<URI> uriStatic = mockStatic(URI.class)) {
			uriStatic.when(() -> URI.create(mockTokenEndpoint)).thenReturn(expectedObject);
			// Act
			URI returnObject = cut.createAuthUri(mockTokenEndpoint);
			// Assert
			assertEquals(returnObject, expectedObject);
		}
	}

}

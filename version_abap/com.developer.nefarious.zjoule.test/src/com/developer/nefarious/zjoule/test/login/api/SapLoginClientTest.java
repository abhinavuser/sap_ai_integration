package com.developer.nefarious.zjoule.test.login.api;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpRequest.Builder;
import java.net.http.HttpResponse;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.MockitoAnnotations;

import com.developer.nefarious.zjoule.plugin.auth.IAuthClient;
import com.developer.nefarious.zjoule.plugin.login.api.GetDeploymentsResponse;
import com.developer.nefarious.zjoule.plugin.login.api.GetResourceGroupsResponse;
import com.developer.nefarious.zjoule.plugin.login.api.ISapLoginClient;
import com.developer.nefarious.zjoule.plugin.login.api.ISapLoginClientHelper;
import com.developer.nefarious.zjoule.plugin.login.api.SapLoginClient;
import com.developer.nefarious.zjoule.plugin.models.ServiceKey;

public class SapLoginClientTest {

	private ISapLoginClient cut;

	MockedStatic<HttpClient> mockedStaticHttpClient;

	MockedStatic<HttpRequest> mockedStaticHttpRequest;

	@Mock
	private HttpClient mockHttpClient;

	@Mock
	private ServiceKey mockServiceKey;

	@Mock
	private IAuthClient mockAuthClient;

	@Mock
	private ISapLoginClientHelper mockSapLoginClientHelper;

	@Mock
	private Builder mockBuilder;

	@Mock
	private HttpRequest mockHttpRequest;

	@Mock
	private HttpResponse mockHttpResponse;

	@BeforeEach
	public void setUp() {
		MockitoAnnotations.openMocks(this);

		mockedStaticHttpClient = mockStatic(HttpClient.class);
		mockedStaticHttpClient.when(HttpClient::newHttpClient).thenReturn(mockHttpClient);

		mockedStaticHttpRequest = mockStatic(HttpRequest.class);
		mockedStaticHttpRequest.when(HttpRequest::newBuilder).thenReturn(mockBuilder);

		cut = spy(new SapLoginClient(mockSapLoginClientHelper, mockAuthClient));
	}

	@Test
	public void shouldPlumbDeployments() throws IOException, InterruptedException {
		// Arrange
		GetDeploymentsResponse expectedValue = mock(GetDeploymentsResponse.class);

		String mockResourceGroup = "selected-resource-group";

		String mockServiceURL = "https://some-url.com";
		when(mockServiceKey.getServiceURL()).thenReturn(mockServiceURL);

		String mockEndpointInStringFormat = mockServiceURL + "/lm/deployments";
		URI mockEndpointInURIFormat = mock(URI.class);
		when(mockSapLoginClientHelper.createAuthUri(mockEndpointInStringFormat)).thenReturn(mockEndpointInURIFormat);
		when(mockBuilder.uri(mockEndpointInURIFormat)).thenReturn(mockBuilder);

		String mockToken = "access-token";
		when(mockAuthClient.getNewAccessToken(mockServiceKey)).thenReturn(mockToken);

		String mockAuthorization = "Bearer " + mockToken;
		when(mockBuilder.header("Authorization", mockAuthorization)).thenReturn(mockBuilder);

		when(mockBuilder.header("AI-Resource-Group", mockResourceGroup)).thenReturn(mockBuilder);
		when(mockBuilder.GET()).thenReturn(mockBuilder);
		when(mockBuilder.build()).thenReturn(mockHttpRequest);
		when(mockHttpClient.send(mockHttpRequest, HttpResponse.BodyHandlers.ofString())).thenReturn(mockHttpResponse);

		String mockResponseBody = "response-content";
		when(mockHttpResponse.body()).thenReturn(mockResponseBody);
		when(mockSapLoginClientHelper.parseDeploymentsResponseToObject(mockResponseBody)).thenReturn(expectedValue);

		// Act
		GetDeploymentsResponse returnValue = cut.getDeployments(mockServiceKey, mockResourceGroup);

		// Assert
		assertEquals(expectedValue, returnValue);
		verify(mockBuilder).uri(mockEndpointInURIFormat);
		verify(mockBuilder).header("Authorization", mockAuthorization);
		verify(mockBuilder).header("AI-Resource-Group", mockResourceGroup);
		verify(mockBuilder).GET();
	}

	@Test
	public void shouldPlumbResourceGroups() throws IOException, InterruptedException {
		// Arrange
		GetResourceGroupsResponse expectedValue = mock(GetResourceGroupsResponse.class);

		String mockServiceURL = "https://some-url.com";
		when(mockServiceKey.getServiceURL()).thenReturn(mockServiceURL);

		String mockEndpointInStringFormat = mockServiceURL + "/admin/resourceGroups";
		URI mockEndpointInURIFormat = mock(URI.class);
		when(mockSapLoginClientHelper.createAuthUri(mockEndpointInStringFormat)).thenReturn(mockEndpointInURIFormat);
		when(mockBuilder.uri(mockEndpointInURIFormat)).thenReturn(mockBuilder);

		String mockToken = "access-token";
		when(mockAuthClient.getNewAccessToken(mockServiceKey)).thenReturn(mockToken);

		String mockAuthorization = "Bearer " + mockToken;
		when(mockBuilder.header("Authorization", mockAuthorization)).thenReturn(mockBuilder);

		when(mockBuilder.GET()).thenReturn(mockBuilder);
		when(mockBuilder.build()).thenReturn(mockHttpRequest);
		when(mockHttpClient.send(mockHttpRequest, HttpResponse.BodyHandlers.ofString())).thenReturn(mockHttpResponse);

		String mockResponseBody = "response-content";
		when(mockHttpResponse.body()).thenReturn(mockResponseBody);
		when(mockSapLoginClientHelper.parseResourceGroupsResponseToObject(mockResponseBody)).thenReturn(expectedValue);

		// Act
		GetResourceGroupsResponse returnValue = cut.getResourceGroups(mockServiceKey);

		// Assert
		assertEquals(expectedValue, returnValue);
		verify(mockBuilder).uri(mockEndpointInURIFormat);
		verify(mockBuilder).header("Authorization", mockAuthorization);
		verify(mockBuilder).GET();
	}

	@AfterEach
	public void tearDown() {
		if (mockedStaticHttpClient != null) {
			mockedStaticHttpClient.close();
		}
		if (mockedStaticHttpRequest != null) {
			mockedStaticHttpRequest.close();
		}
	}

}
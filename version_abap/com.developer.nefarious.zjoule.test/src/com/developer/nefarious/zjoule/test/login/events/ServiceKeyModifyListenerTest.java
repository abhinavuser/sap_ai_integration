package com.developer.nefarious.zjoule.test.login.events;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.io.IOException;

import org.eclipse.swt.events.ModifyEvent;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.MockitoAnnotations;

import com.developer.nefarious.zjoule.plugin.login.api.GetResourceGroupsResponse;
import com.developer.nefarious.zjoule.plugin.login.api.ISapLoginClient;
import com.developer.nefarious.zjoule.plugin.login.events.ServiceKeyModifyListener;
import com.developer.nefarious.zjoule.plugin.login.pages.FirstSapLoginWizardPage;
import com.developer.nefarious.zjoule.plugin.login.utils.JsonValidator;
import com.developer.nefarious.zjoule.plugin.models.ServiceKey;
import com.google.gson.Gson;

public class ServiceKeyModifyListenerTest {

	public static final String INVALID_INPUT_MESSAGE = "Invalid service key. Please provide valid credentials.";

	private ServiceKeyModifyListener cut;

	@Mock
	private FirstSapLoginWizardPage mockFirstLoginWizardPage;

	@Mock
	private ISapLoginClient mockSapLoginClient;

	@Mock
	private Gson mockGson;

	@Mock
	private ServiceKey mockServiceKey;

	@BeforeEach
	public void setUp() {
		MockitoAnnotations.openMocks(this);
		cut = spy(new ServiceKeyModifyListener(mockFirstLoginWizardPage, mockSapLoginClient, mockGson));
	}

	@Test
	public void shouldDisableTheNextButtonIfInputIsEmpty() {
		// Arrange
		ModifyEvent mockModifyEvent = mock(ModifyEvent.class);
		String mockInputText = "";
		when(mockFirstLoginWizardPage.getInputText()).thenReturn(mockInputText);
		// Act
		cut.modifyText(mockModifyEvent);
		// Assert
		verify(mockFirstLoginWizardPage).setValidationError(null);
		verify(mockFirstLoginWizardPage).setPageComplete(false);
	}

	@Test
	public void shouldDisableTheNextButtonIfInputIsInvalid() {
		// Arrange
		ModifyEvent mockModifyEvent = mock(ModifyEvent.class);
		String mockInputText = "{ \"attribute\": \"value\" }";
		String mockInputTextTrimmed = mockInputText.trim();
		when(mockFirstLoginWizardPage.getInputText()).thenReturn(mockInputTextTrimmed);
		try (MockedStatic<JsonValidator> mockedJsonValidatorStatic = mockStatic(JsonValidator.class)) {
			mockedJsonValidatorStatic.when(() -> JsonValidator.isValidJson(mockInputTextTrimmed)).thenReturn(false);
			// Act
			cut.modifyText(mockModifyEvent);
			// Assert
			verify(mockFirstLoginWizardPage).setValidationError(INVALID_INPUT_MESSAGE);
			verify(mockFirstLoginWizardPage).setPageComplete(false);
		}
	}

	@Test
	public void shouldDisableTheNextButtonIfServiceKeyIsInvalid() {
		// Arrange
		ModifyEvent mockModifyEvent = mock(ModifyEvent.class);
		String mockInputText = "{ \"attribute\": \"value\" }";
		String mockInputTextTrimmed = mockInputText.trim();
		when(mockFirstLoginWizardPage.getInputText()).thenReturn(mockInputTextTrimmed);
		try (MockedStatic<JsonValidator> mockedJsonValidatorStatic = mockStatic(JsonValidator.class)) {
			mockedJsonValidatorStatic.when(() -> JsonValidator.isValidJson(mockInputTextTrimmed)).thenReturn(true);
		}
		when(mockGson.fromJson(mockInputTextTrimmed, ServiceKey.class)).thenReturn(mockServiceKey);
		when(mockServiceKey.isValid()).thenReturn(false);
		// Act
		cut.modifyText(mockModifyEvent);
		// Assert
		verify(mockFirstLoginWizardPage).setValidationError(INVALID_INPUT_MESSAGE);
		verify(mockFirstLoginWizardPage).setPageComplete(false);
	}

	@Test
	public void shouldEnableTheNextButtonIfInputIsValid() throws IOException, InterruptedException {
		// Arrange
		ModifyEvent mockModifyEvent = mock(ModifyEvent.class);
		String mockInputText = "{ \"attribute\": \"value\" }";
		String mockInputTextTrimmed = mockInputText.trim();
		when(mockFirstLoginWizardPage.getInputText()).thenReturn(mockInputTextTrimmed);
		try (MockedStatic<JsonValidator> mockedJsonValidatorStatic = mockStatic(JsonValidator.class)) {
			mockedJsonValidatorStatic.when(() -> JsonValidator.isValidJson(mockInputTextTrimmed)).thenReturn(true);
		}
		when(mockGson.fromJson(mockInputTextTrimmed, ServiceKey.class)).thenReturn(mockServiceKey);
		when(mockServiceKey.isValid()).thenReturn(true);
		GetResourceGroupsResponse mockGetResourceGroupsResponse = mock(GetResourceGroupsResponse.class);
		when(mockSapLoginClient.getResourceGroups(mockServiceKey)).thenReturn(mockGetResourceGroupsResponse);
		// Act
		cut.modifyText(mockModifyEvent);
		// Assert
		verify(mockFirstLoginWizardPage).setValidationError(null);
		verify(mockFirstLoginWizardPage).setPageComplete(true);
		verify(mockFirstLoginWizardPage).setResourceGroupsOnTheSecondPage(mockGetResourceGroupsResponse);
		verify(mockFirstLoginWizardPage).setServiceKey(mockServiceKey);
	}

	@Test
	public void shouldGracefullyHandleAnyError() throws IOException, InterruptedException {
		// Arrange
		ModifyEvent mockModifyEvent = mock(ModifyEvent.class);
		String mockInputText = "{ \"attribute\": \"value\" }";
		String mockInputTextTrimmed = mockInputText.trim();
		when(mockFirstLoginWizardPage.getInputText()).thenReturn(mockInputTextTrimmed);
		try (MockedStatic<JsonValidator> mockedJsonValidatorStatic = mockStatic(JsonValidator.class)) {
			mockedJsonValidatorStatic.when(() -> JsonValidator.isValidJson(mockInputTextTrimmed)).thenReturn(true);
		}
		when(mockGson.fromJson(mockInputTextTrimmed, ServiceKey.class)).thenReturn(mockServiceKey);
		when(mockServiceKey.isValid()).thenReturn(true);
		when(mockSapLoginClient.getResourceGroups(mockServiceKey)).thenThrow(new IOException());
		// Act
		cut.modifyText(mockModifyEvent);
		// Assert
		verify(mockFirstLoginWizardPage).setValidationError(INVALID_INPUT_MESSAGE);
		verify(mockFirstLoginWizardPage).setPageComplete(false);
	}

}

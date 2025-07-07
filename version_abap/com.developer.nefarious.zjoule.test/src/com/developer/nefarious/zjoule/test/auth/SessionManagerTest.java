package com.developer.nefarious.zjoule.test.auth;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.eclipse.swt.browser.Browser;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.MockitoAnnotations;

import com.developer.nefarious.zjoule.plugin.auth.SessionManager;
import com.developer.nefarious.zjoule.plugin.core.functions.TagHandler;
import com.developer.nefarious.zjoule.plugin.memory.EclipseMemory;
import com.developer.nefarious.zjoule.plugin.memory.MemoryAccessToken;
import com.developer.nefarious.zjoule.plugin.memory.MemoryDeployment;
import com.developer.nefarious.zjoule.plugin.memory.MemoryResourceGroup;
import com.developer.nefarious.zjoule.plugin.memory.MemoryServiceKey;

public class SessionManagerTest {

	private MockedStatic<MemoryAccessToken> mockedStaticMemoryAccessToken;

	private MockedStatic<MemoryServiceKey> mockedStaticMemoryServiceKey;

	private MockedStatic<MemoryResourceGroup> mockedStaticMemoryResourceGroup;

	private MockedStatic<MemoryDeployment> mockedStaticMemoryDeployment;

	private MockedStatic<TagHandler> mockedStaticTagHandler;

	@Mock
	private MemoryAccessToken mockMemoryAccessToken;

	@Mock
	private MemoryServiceKey mockMemoryServiceKey;

	@Mock
	private MemoryResourceGroup mockMemoryResourceGroup;

	@Mock
	private MemoryDeployment mockMemoryDeployment;

	@BeforeEach
	public void setUp() {
		MockitoAnnotations.openMocks(this);

		mockedStaticMemoryAccessToken = mockStatic(MemoryAccessToken.class);
		mockedStaticMemoryServiceKey = mockStatic(MemoryServiceKey.class);
		mockedStaticMemoryResourceGroup = mockStatic(MemoryResourceGroup.class);
		mockedStaticMemoryDeployment = mockStatic(MemoryDeployment.class);
		mockedStaticTagHandler = mockStatic(TagHandler.class);

		mockedStaticMemoryAccessToken.when(MemoryAccessToken::getInstance).thenReturn(mockMemoryAccessToken);
		mockedStaticMemoryServiceKey.when(MemoryServiceKey::getInstance).thenReturn(mockMemoryServiceKey);
		mockedStaticMemoryResourceGroup.when(MemoryResourceGroup::getInstance).thenReturn(mockMemoryResourceGroup);
		mockedStaticMemoryDeployment.when(MemoryDeployment::getInstance).thenReturn(mockMemoryDeployment);
	}

	@Test
	public void shouldLogin() {
		// Arrange
		Browser mockBrowser = mock(Browser.class);
		// Act
		SessionManager.login(mockBrowser);
		// Assert
		verify(mockBrowser).execute("login();");
		mockedStaticTagHandler.verify(() -> TagHandler.update(mockBrowser));
	}

	@Test
	public void shouldLogout() {
		// Arrange
		Browser mockBrowser = mock(Browser.class);
		EclipseMemory mockEclipseMemory = mock(EclipseMemory.class);
		// Act
		SessionManager.logout(mockBrowser, mockEclipseMemory);
		// Assert
		verify(mockEclipseMemory).clearAll();
		verify(mockBrowser).execute("logout();");
	}

	@Test
	public void shouldReturnFalseIfAccessTokenIsMissing() {
		// Arrange
		when(mockMemoryAccessToken.isEmpty()).thenReturn(false);
		when(mockMemoryServiceKey.isEmpty()).thenReturn(true);
		when(mockMemoryResourceGroup.isEmpty()).thenReturn(true);
		when(mockMemoryDeployment.isEmpty()).thenReturn(true);
		// Act
		Boolean returnValue = SessionManager.isUserLoggedIn();
		// Assert
		assertFalse(returnValue);
	}

	@Test
	public void shouldReturnFalseIfDeploymentIsMissing() {
		// Arrange
		when(mockMemoryAccessToken.isEmpty()).thenReturn(true);
		when(mockMemoryServiceKey.isEmpty()).thenReturn(true);
		when(mockMemoryResourceGroup.isEmpty()).thenReturn(true);
		when(mockMemoryDeployment.isEmpty()).thenReturn(false);
		// Act
		Boolean returnValue = SessionManager.isUserLoggedIn();
		// Assert
		assertFalse(returnValue);
	}

	@Test
	public void shouldReturnFalseIfResourceGroupIsMissing() {
		// Arrange
		when(mockMemoryAccessToken.isEmpty()).thenReturn(true);
		when(mockMemoryServiceKey.isEmpty()).thenReturn(true);
		when(mockMemoryResourceGroup.isEmpty()).thenReturn(false);
		when(mockMemoryDeployment.isEmpty()).thenReturn(true);
		// Act
		Boolean returnValue = SessionManager.isUserLoggedIn();
		// Assert
		assertFalse(returnValue);
	}

	@Test
	public void shouldReturnFalseIfServiceKeyIsMissing() {
		// Arrange
		when(mockMemoryAccessToken.isEmpty()).thenReturn(true);
		when(mockMemoryServiceKey.isEmpty()).thenReturn(false);
		when(mockMemoryResourceGroup.isEmpty()).thenReturn(true);
		when(mockMemoryDeployment.isEmpty()).thenReturn(true);
		// Act
		Boolean returnValue = SessionManager.isUserLoggedIn();
		// Assert
		assertFalse(returnValue);
	}

	@Test
	public void shouldReturnTrueIfUserIsLoggedIn() {
		// Arrange
		when(mockMemoryAccessToken.isEmpty()).thenReturn(false);
		when(mockMemoryServiceKey.isEmpty()).thenReturn(false);
		when(mockMemoryResourceGroup.isEmpty()).thenReturn(false);
		when(mockMemoryDeployment.isEmpty()).thenReturn(false);
		// Act
		Boolean returnValue = SessionManager.isUserLoggedIn();
		// Assert
		assertTrue(returnValue);
	}

	@AfterEach
	public void tearDown() {
		if (mockedStaticMemoryAccessToken != null) {
			mockedStaticMemoryAccessToken.close();
		}
		if (mockedStaticMemoryServiceKey != null) {
			mockedStaticMemoryServiceKey.close();
		}
		if (mockedStaticMemoryResourceGroup != null) {
			mockedStaticMemoryResourceGroup.close();
		}
		if (mockedStaticMemoryDeployment != null) {
			mockedStaticMemoryDeployment.close();
		}
		if (mockedStaticTagHandler != null) {
			mockedStaticTagHandler.close();
		}
	}

}

import Netrofit
import XCTest

private let provider = NetrofitProvider(baseURL: "https://open.bigmodel.cn", plugins: [LogInterceptors()])

struct Message: Codable {
    let role: String
    let content: String
}

struct LLMResponse: Codable {
    struct LLMRespMessage: Codable {
        let role: String
        let content: String?
        let reasoning_content: String?
    }

    struct Choice: Codable {
        let index: Int
        let delta: LLMRespMessage
    }

    let id: String
    let created: TimeInterval
    let model: String
    let choices: [Choice]
}

@API
struct LLMAPI {
    @POST("api/paas/v4/chat/completions")
    @EventStreaming
    @Headers(["Authorization": "Bearer f6447b8b2b434dcbbd237ec8d7f56180.HXWdENeBbinRuuSP"])
    func completions(model: String, messages: [Message], stream: Bool = true) async throws -> AsyncThrowingStream<LLMResponse, Error>
}

final class LLMSSETests: XCTestCase {
    let api = LLMAPI(provider)

    func testCompletions() async throws {
        var text = ""
        let messages = [Message(role: "user", content: "hello, who are you?")]
        let stream = try await api.completions(model: "GLM-4.5-Flash", messages: messages)

        do {
            for try await event in stream {
                let reasoningContent = event.choices.compactMap(\.delta.reasoning_content).joined()
                let content = event.choices.compactMap(\.delta.content).joined()
                text.append(reasoningContent)
                text.append(content)

                if !reasoningContent.isEmpty {
                    print(reasoningContent, terminator: "")
                }
                if !content.isEmpty {
                    print(content, terminator: "")
                }
            }
        } catch {
            // [DONE]
            print(error)
        }

        XCTAssertTrue(text.contains("GLM"))
    }
}
